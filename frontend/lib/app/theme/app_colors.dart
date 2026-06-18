import 'package:flutter/material.dart';

class AppColorScheme {
  final Color primary;
  final Color primaryVariant;
  final Color secondary;
  final Color secondaryVariant;
  final Color surface;
  final Color background;
  final Color canvasBackground;
  final Color canvasGrid;
  final Color strokeDefault;
  final Color error;
  final Color errorSurface;
  final Color success;
  final Color successSurface;
  final Color warning;
  final Color warningSurface;
  final Color onPrimary;
  final Color onSecondary;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color onBackground;
  final Color divider;
  final Color overlay;

  const AppColorScheme({
    required this.primary,
    required this.primaryVariant,
    required this.secondary,
    required this.secondaryVariant,
    required this.surface,
    required this.background,
    required this.canvasBackground,
    required this.canvasGrid,
    required this.strokeDefault,
    required this.error,
    required this.errorSurface,
    required this.success,
    required this.successSurface,
    required this.warning,
    required this.warningSurface,
    required this.onPrimary,
    required this.onSecondary,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.onBackground,
    required this.divider,
    required this.overlay,
  });
}

class AppColors {
  static const light = AppColorScheme(
    primary: Color(0xFF6366F1),
    primaryVariant: Color(0xFF4F46E5),
    secondary: Color(0xFF8B5CF6),
    secondaryVariant: Color(0xFF7C3AED),
    surface: Color(0xFFFFFFFF),
    background: Color(0xFFF8FAFC),
    canvasBackground: Color(0xFFFFFFFF),
    canvasGrid: Color(0xFFE2E8F0),
    strokeDefault: Color(0xFF1E293B),
    error: Color(0xFFEF4444),
    errorSurface: Color(0xFFFEF2F2),
    success: Color(0xFF22C55E),
    successSurface: Color(0xFFF0FDF4),
    warning: Color(0xFFF59E0B),
    warningSurface: Color(0xFFFFFBEB),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1E293B),
    onSurfaceVariant: Color(0xFF64748B),
    onBackground: Color(0xFF0F172A),
    divider: Color(0xFFE2E8F0),
    overlay: Color(0x800F172A),
  );

  static const dark = AppColorScheme(
    primary: Color(0xFF818CF8),
    primaryVariant: Color(0xFF6366F1),
    secondary: Color(0xFFA78BFA),
    secondaryVariant: Color(0xFF8B5CF6),
    surface: Color(0xFF1E293B),
    background: Color(0xFF0F172A),
    canvasBackground: Color(0xFF1A1A2E),
    canvasGrid: Color(0xFF334155),
    strokeDefault: Color(0xFFE2E8F0),
    error: Color(0xFFF87171),
    errorSurface: Color(0xFF450A0A),
    success: Color(0xFF4ADE80),
    successSurface: Color(0xFF052E16),
    warning: Color(0xFFFBBF24),
    warningSurface: Color(0xFF451A03),
    onPrimary: Color(0xFF0F172A),
    onSecondary: Color(0xFF0F172A),
    onSurface: Color(0xFFF1F5F9),
    onSurfaceVariant: Color(0xFF94A3B8),
    onBackground: Color(0xFFF8FAFC),
    divider: Color(0xFF334155),
    overlay: Color(0x99000000),
  );

  // Graph colors
  static const graphColorsLight = [
    Color(0xFF6366F1),
    Color(0xFFEC4899),
    Color(0xFF14B8A6),
    Color(0xFFF59E0B),
    Color(0xFF8B5CF6),
  ];

  static const graphColorsDark = [
    Color(0xFF818CF8),
    Color(0xFFF472B6),
    Color(0xFF2DD4BF),
    Color(0xFFFBBF24),
    Color(0xFFA78BFA),
  ];

  static const graphAxisLight = Color(0xFF64748B);
  static const graphAxisDark = Color(0xFF94A3B8);

  static const graphGridLight = Color(0xFFE2E8F0);
  static const graphGridDark = Color(0xFF334155);
}
