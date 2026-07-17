// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'package:protopharma/data/app_database.dart';
import 'package:protopharma/main.dart';

void main() {
  testWidgets('App renders main layout and home screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final db = AppDatabase();
    final fakeFirestore = FakeFirebaseFirestore();
    await tester.pumpWidget(MyApp(db: db, firestore: fakeFirestore));

    // Verify that our home screen renders and shows the welcome message.
    expect(find.text('Welcome to protopharma'), findsOneWidget);
    expect(find.text('Search for a drug'), findsOneWidget);
  });
}
