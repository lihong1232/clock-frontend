@echo off
setlocal

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

echo [INFO] Installing dependencies...
pushd "%PROJECT_DIR%"
call flutter pub get
if errorlevel 1 (
  echo [ERROR] flutter pub get failed.
  popd
  exit /b 1
)

REM iOS build/run is only supported on macOS with Xcode.
echo [ERROR] iOS run is not supported from Windows batch scripts.
echo Use a macOS machine and run:
echo   cd flutter_alarm_app
echo   flutter run -d ios
popd
exit /b 1
