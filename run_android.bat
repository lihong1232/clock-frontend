@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM Ensure script runs from repository root regardless of caller cwd
set "SCRIPT_DIR=%~dp0"
set "PROJECT_DIR=%SCRIPT_DIR%flutter_alarm_app"

if not exist "%PROJECT_DIR%\pubspec.yaml" (
  echo [ERROR] Could not find Flutter project at: %PROJECT_DIR%
  echo Make sure this script is in the repository root.
  exit /b 1
)

echo [INFO] Project: %PROJECT_DIR%

where flutter >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Flutter is not in PATH. Install Flutter and add it to PATH first.
  exit /b 1
)

pushd "%PROJECT_DIR%"

REM Force a modern JDK for Gradle (Gradle 9 requires Java 17+)
if exist "C:\Program Files\Android\Android Studio\jbr\bin\java.exe" (
  set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
  set "PATH=%JAVA_HOME%\bin;%PATH%"
)

REM Ensure Gradle wrapper download honors enterprise/root certificates on Windows
set "USER_TRUSTSTORE=%USERPROFILE%\.java\gradle-truststore.p12"
if exist "%USER_TRUSTSTORE%" (
  set "JAVA_TOOL_OPTIONS=-Djavax.net.ssl.trustStore=%USER_TRUSTSTORE% -Djavax.net.ssl.trustStoreType=PKCS12 -Djavax.net.ssl.trustStorePassword=changeit -Dcom.sun.net.ssl.checkRevocation=false %JAVA_TOOL_OPTIONS%"
  set "GRADLE_OPTS=-Djavax.net.ssl.trustStore=%USER_TRUSTSTORE% -Djavax.net.ssl.trustStoreType=PKCS12 -Djavax.net.ssl.trustStorePassword=changeit -Dcom.sun.net.ssl.checkRevocation=false %GRADLE_OPTS%"
)

echo [INFO] Installing dependencies...
call flutter pub get
if errorlevel 1 (
  echo [ERROR] flutter pub get failed.
  popd
  exit /b 1
)

echo [INFO] Checking Android toolchain...
call flutter doctor -v > "%TEMP%\flutter_doctor_android.txt"
findstr /I /C:"Unable to locate Android SDK." "%TEMP%\flutter_doctor_android.txt" >nul
if not errorlevel 1 (
  echo [ERROR] Android SDK not found.
  echo Install Android Studio and Android SDK first:
  echo   https://developer.android.com/studio
  echo Then run:
  echo   flutter config --android-sdk ^<YOUR_SDK_PATH^>
  echo   flutter doctor --android-licenses
  popd
  exit /b 1
)

echo [INFO] Checking Android devices...
set "ANDROID_DEVICE_ID="
set "SDK_ROOT=%LOCALAPPDATA%\Android\Sdk"
set "ADB_PATH=%SDK_ROOT%\platform-tools\adb.exe"
if not exist "%ADB_PATH%" set "ADB_PATH=adb"

"%ADB_PATH%" devices > "%TEMP%\adb_devices.txt" 2>nul
for /f "tokens=1,2" %%I in ('findstr /R /C:"^emulator-[0-9][0-9]*" "%TEMP%\adb_devices.txt"') do (
  if /I "%%J"=="device" if not defined ANDROID_DEVICE_ID set "ANDROID_DEVICE_ID=%%I"
)

if not defined ANDROID_DEVICE_ID (
  echo [WARN] No Android device/emulator detected.
  echo [INFO] Trying to launch an Android emulator automatically...

  set "EMULATOR_ID=Pixel_7_API_35"

  if defined EMULATOR_ID (
    echo [INFO] Launching emulator: !EMULATOR_ID!
    call flutter emulators --launch !EMULATOR_ID!
    if errorlevel 1 (
      echo [WARN] Failed to launch emulator automatically.
      echo Run this manually:
      echo   flutter emulators
      echo   flutter emulators --launch ^<EMULATOR_ID^>
    ) else (
      echo [INFO] Emulator launch requested. Waiting for device registration...
      "%ADB_PATH%" wait-for-device >nul 2>nul
      "%ADB_PATH%" devices > "%TEMP%\adb_devices.txt" 2>nul
      for /f "tokens=1,2" %%I in ('findstr /R /C:"^emulator-[0-9][0-9]*" "%TEMP%\adb_devices.txt"') do (
        if /I "%%J"=="device" if not defined ANDROID_DEVICE_ID set "ANDROID_DEVICE_ID=%%I"
      )
    )
  ) else (
    echo [WARN] No configured emulator found.
    echo Create one in Android Studio Device Manager, then re-run this script.
  )
)

if not defined ANDROID_DEVICE_ID (
  echo [ERROR] Android device is still unavailable.
  echo Start an emulator in Android Studio and re-run this script.
  popd
  exit /b 1
)

echo [INFO] Launching on Android device/emulator: !ANDROID_DEVICE_ID!
call flutter run -d !ANDROID_DEVICE_ID!
set "RC=%ERRORLEVEL%"
popd
exit /b %RC%
