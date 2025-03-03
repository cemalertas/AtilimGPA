import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gpatwo/main.dart';

void main() {
  testWidgets('Basic widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(
      isFirstLaunch: false,
      isDarkMode: false,
      language: 'tr',
    ));

    // Verify that our app starts without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}