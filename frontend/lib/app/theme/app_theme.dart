import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final AppColorScheme colorScheme;

  const AppThemeExtension({required this.colorScheme});

  @override
  AppThemeExtension copyWith({AppColorScheme? colorScheme}) {
    return AppThemeExtension(colorScheme: colorScheme ?? this.colorScheme);
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return this;
  }
}

extension AppThemeContext on BuildContext {
  AppColorScheme get appColorScheme => Theme.of(this).extension<AppThemeExtension>()!.colorScheme;
}

class AppTheme {
  static ThemeData get lightTheme {
    final base = ThemeData.light();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.light.background,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.light.primary,
        surface: AppColors.light.surface,
        error: AppColors.light.error,
      ),
      textTheme: base.textTheme.copyWith(
        displayLarge: AppTypography.displayLarge,
        headlineLarge: AppTypography.headlineLarge,
        headlineMedium: AppTypography.headlineMedium,
        titleLarge: AppTypography.titleLarge,
        titleMedium: AppTypography.titleMedium,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelLarge,
        labelMedium: AppTypography.labelMedium,
        labelSmall: AppTypography.labelSmall,
      ),
      extensions: [
        const AppThemeExtension(colorScheme: AppColors.light),
      ],
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.dark.background,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.dark.primary,
        surface: AppColors.dark.surface,
        error: AppColors.dark.error,
      ),
      textTheme: base.textTheme.copyWith(
        displayLarge: AppTypography.displayLarge,
        headlineLarge: AppTypography.headlineLarge,
        headlineMedium: AppTypography.headlineMedium,
        titleLarge: AppTypography.titleLarge,
        titleMedium: AppTypography.titleMedium,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelLarge,
        labelMedium: AppTypography.labelMedium,
        labelSmall: AppTypography.labelSmall,
      ),
      extensions: [
        const AppThemeExtension(colorScheme: AppColors.dark),
      ],
    );
  }
}
