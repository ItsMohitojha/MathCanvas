import 'package:flutter/material.dart';

class AppTypography {
  static const fontFamilyUI = 'Inter';
  static const fontFamilyMath = 'StixTwoMath';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamilyUI,
    fontSize: 32.0,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.5,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamilyUI,
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0.0,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamilyUI,
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.0,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamilyUI,
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    height: 1.44,
    letterSpacing: 0.0,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamilyUI,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.15,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamilyUI,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamilyUI,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.25,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamilyUI,
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.4,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamilyUI,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamilyUI,
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamilyUI,
    fontSize: 10.0,
    fontWeight: FontWeight.w500,
    height: 1.6,
    letterSpacing: 0.5,
  );

  static const TextStyle mathDisplay = TextStyle(
    fontFamily: fontFamilyMath,
    fontSize: 18.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.0,
  );

  static const TextStyle mathResult = TextStyle(
    fontFamily: fontFamilyMath,
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.0,
  );
}
