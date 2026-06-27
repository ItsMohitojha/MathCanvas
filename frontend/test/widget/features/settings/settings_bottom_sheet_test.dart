import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mathcanvas/app/theme/app_theme.dart';
import 'package:mathcanvas/features/settings/presentation/widgets/settings_bottom_sheet.dart';
import 'package:mathcanvas/features/settings/presentation/providers/theme_provider.dart';

void main() {
  group('SettingsBottomSheet Widget Tests', () {
    late SharedPreferences sharedPreferences;

    setUp(() async {
      SharedPreferences.setMockInitialValues({'user_theme_mode': 'system'});
      sharedPreferences = await SharedPreferences.getInstance();
    });

    Widget buildTestWidget() {
      return ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: ElevatedButton(
                  onPressed: () => SettingsBottomSheet.show(context),
                  child: const Text('Show Settings'),
                ),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('displays theme options and tap dark theme persists it', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Open bottom sheet
      await tester.tap(find.text('Show Settings'));
      await tester.pumpAndSettle();

      // Verify title and headers
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Appearance'), findsOneWidget);

      // Verify theme options exist
      expect(find.text('System'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);

      // Tap on Dark option
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      // Verify stored value in shared preferences
      expect(sharedPreferences.getString('user_theme_mode'), equals('dark'));
    });
  });
}
