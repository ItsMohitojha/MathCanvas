import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mathcanvas/features/settings/presentation/providers/theme_provider.dart';

void main() {
  group('ThemeNotifier Tests', () {
    late SharedPreferences sharedPreferences;

    setUp(() async {
      SharedPreferences.setMockInitialValues({'user_theme_mode': 'dark'});
      sharedPreferences = await SharedPreferences.getInstance();
    });

    test('initial state loads dark theme from SharedPreferences', () {
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
      );
      expect(container.read(themeProvider), equals(ThemeMode.dark));
    });

    test('initial state defaults to system theme when no value saved', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      expect(container.read(themeProvider), equals(ThemeMode.system));
    });

    test('setThemeMode updates state and persists to SharedPreferences', () async {
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
      );
      final notifier = container.read(themeProvider.notifier);
      
      await notifier.setThemeMode(ThemeMode.light);
      expect(container.read(themeProvider), equals(ThemeMode.light));
      expect(sharedPreferences.getString('user_theme_mode'), equals('light'));
    });
  });
}
