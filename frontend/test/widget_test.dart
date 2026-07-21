// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

import 'package:protopharma/data/app_database.dart';
import 'package:protopharma/main.dart';

void main() {
  testWidgets('App renders main layout and home screen smoke test', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    final db = AppDatabase();
    await tester.pumpWidget(MyApp(db: db));

    // Verify that the dashboard layout renders.
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Critical Alerts'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await db.close();
  });
}
