import 'package:flutter/material.dart';

void main() {
  runApp(const AlarmApp());
}

class AlarmApp extends StatelessWidget {
  const AlarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '闹钟',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
        scaffoldBackgroundColor: const Color(0xFFF7F9FB),
        useMaterial3: true,
      ),
      home: const AlarmHomePage(),
    );
  }
}

class AlarmItem {
  const AlarmItem({
    required this.name,
    required this.time,
    required this.repeat,
    required this.enabled,
  });

  final String name;
  final String time;
  final String repeat;
  final bool enabled;

  AlarmItem copyWith({bool? enabled}) {
    return AlarmItem(
      name: name,
      time: time,
      repeat: repeat,
      enabled: enabled ?? this.enabled,
    );
  }
}

class AlarmHomePage extends StatefulWidget {
  const AlarmHomePage({super.key});

  @override
  State<AlarmHomePage> createState() => _AlarmHomePageState();
}

class _AlarmHomePageState extends State<AlarmHomePage> {
  List<AlarmItem> alarms = const [
    AlarmItem(name: '起床闹钟', time: '07:30', repeat: '周一, 周二, 周三, 周四, 周五', enabled: true),
    AlarmItem(name: '午休', time: '13:00', repeat: '每天', enabled: true),
    AlarmItem(name: '健身', time: '18:30', repeat: '周二, 周四', enabled: false),
  ];

  int currentTabIndex = 1;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF4F46E5);
    const onSurface = Color(0xFF191C1E);
    const onSurfaceVariant = Color(0xFF464555);
    const cardActive = Color(0xFFFFFFFF);
    const cardInactive = Color(0xFFF2F4F6);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FB),
        elevation: 0,
        title: const Text(
          '闹钟',
          style: TextStyle(
            color: onSurface,
            fontWeight: FontWeight.w800,
            fontSize: 28,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add, color: primary),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '下一个闹钟 07:30',
                style: TextStyle(
                  color: onSurfaceVariant,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '开启美好的一天',
                style: TextStyle(
                  color: onSurface,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 28),
              ...List.generate(alarms.length, (index) {
                final alarm = alarms[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: alarm.enabled ? cardActive : cardInactive,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFECEEF0)),
                      boxShadow: alarm.enabled
                          ? const [
                              BoxShadow(
                                color: Color.fromRGBO(79, 70, 229, 0.08),
                                blurRadius: 16,
                                offset: Offset(0, 4),
                              ),
                            ]
                          : const [],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Opacity(
                            opacity: alarm.enabled ? 1 : 0.6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  alarm.name,
                                  style: const TextStyle(
                                    color: onSurfaceVariant,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  alarm.time,
                                  style: const TextStyle(
                                    color: onSurface,
                                    fontSize: 42,
                                    fontWeight: FontWeight.w700,
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  alarm.repeat,
                                  style: const TextStyle(
                                    color: Color(0xFF3F465C),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Switch(
                          value: alarm.enabled,
                          activeThumbColor: Colors.white,
                          activeTrackColor: primary,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: const Color(0xFFCBD5E1),
                          onChanged: (value) {
                            setState(() {
                              alarms = [
                                ...alarms.sublist(0, index),
                                alarm.copyWith(enabled: value),
                                ...alarms.sublist(index + 1),
                              ];
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              Opacity(
                opacity: 0.4,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFEAF0FF), Color(0xFFF8FAFC)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.alarm,
                            size: 64,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '添加更多闹钟来保持高效',
                      style: TextStyle(
                        color: onSurfaceVariant,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentTabIndex,
        height: 72,
        indicatorColor: const Color(0xFFDAE2FD),
        backgroundColor: Colors.white,
        onDestinationSelected: (index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.calendar_today_outlined), label: '日程'),
          NavigationDestination(icon: Icon(Icons.alarm), label: '闹钟'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: '我的'),
        ],
      ),
    );
  }
}
