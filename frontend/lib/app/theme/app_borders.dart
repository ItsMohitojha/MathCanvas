import 'package:flutter/material.dart';

class AppBorders {
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  static const double radiusXXLarge = 28.0;
  static const double radiusFull = 9999.0;

  static final BorderRadius smallBorderRadius = BorderRadius.circular(radiusSmall);
  static final BorderRadius mediumBorderRadius = BorderRadius.circular(radiusMedium);
  static final BorderRadius largeBorderRadius = BorderRadius.circular(radiusLarge);
  static final BorderRadius xLargeBorderRadius = BorderRadius.circular(radiusXLarge);
  static final BorderRadius xxLargeBorderRadius = BorderRadius.circular(radiusXXLarge);
  static final BorderRadius fullBorderRadius = BorderRadius.circular(radiusFull);

  // Component-specific shortcuts
  static final BorderRadius cardBorderRadius = largeBorderRadius;
  static final BorderRadius dialogBorderRadius = xxLargeBorderRadius;
  static final BorderRadius toolbarBorderRadius = xLargeBorderRadius;
}
