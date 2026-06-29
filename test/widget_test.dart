import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_tracker/screens/dashboard_screen.dart';

void main() {
  testWidgets('Dashboard screen renders without its own nested scaffold', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

    expect(find.text('Your fitness plan at a glance'), findsOneWidget);
    expect(find.byType(Scaffold), findsNothing);
  });
}
