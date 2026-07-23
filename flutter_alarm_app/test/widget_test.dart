import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_alarm_app/main.dart';

void main() {
  testWidgets('Alarm home page renders mock data', (WidgetTester tester) async {
    await tester.pumpWidget(const AlarmApp());

    expect(find.text('闹钟'), findsNWidgets(2));
    expect(find.text('起床闹钟'), findsOneWidget);
    expect(find.text('午休'), findsOneWidget);
    expect(find.text('健身'), findsOneWidget);
  });
}
