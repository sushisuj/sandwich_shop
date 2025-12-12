import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sandwich_shop/views/settings_screen.dart';
import 'package:sandwich_shop/views/app_styles.dart';

void main() {
  // Helper to pump the real SettingsScreen inside a MaterialApp
  Future<void> _pumpSettingsScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsScreen(),
      ),
    );
  }

  setUp(() {
    // Ensure prefs are mocked for each test run
    SharedPreferences.setMockInitialValues(<String, Object>{
      'fontSize': 16.0,
    });
  });

  testWidgets('shows loading indicator while settings are loading',
      (WidgetTester tester) async {
    await _pumpSettingsScreen(tester);

    // First frame: _isLoading is true, so we should see a CircularProgressIndicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows font size slider after loading',
      (WidgetTester tester) async {
    await _pumpSettingsScreen(tester);

    // Let _loadSettings() run and flip _isLoading to false
    await tester.pump(const Duration(milliseconds: 100));

    // Now the main settings UI should be visible, including the Slider
    expect(find.text('Font Size'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
  });
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _fontSize = 16.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await AppStyles.loadFontSize();
    setState(() {
      _fontSize = AppStyles.baseFontSize;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
          // ...
          ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // includes Back to Order button
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back to Order'),
            ),
          ],
        ),
      ),
    );
  }
}
