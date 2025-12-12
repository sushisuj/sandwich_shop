import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/settings_screen.dart';

void main() {
  // Helper to pump the screen inside a MaterialApp
  Future<void> _pumpSettingsScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsScreen(),
      ),
    );
  }

  testWidgets('shows loading indicator while settings are loading',
      (WidgetTester tester) async {
    await _pumpSettingsScreen(tester);

    // First frame: _isLoading is true, so we should see a CircularProgressIndicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('tapping Back to Order pops the screen after loading',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsScreen(),
      ),
    );

    // Try a few pumps to give loading time to finish
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    final Finder backButtonFinder = find.widgetWithText(
      ElevatedButton,
      'Back to Order',
    );

    // If it's still not there, bail with a useful message
    if (backButtonFinder.evaluate().isEmpty) {
      fail('Back to Order button was not found after waiting for loading.');
    }

    await tester.tap(backButtonFinder);
    await tester.pumpAndSettle();

    // After popping, there should be no Settings app bar title
    expect(find.text('Settings'), findsNothing);
  });
}
