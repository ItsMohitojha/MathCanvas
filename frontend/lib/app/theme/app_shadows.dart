import 'package:flutter/material.dart';

class AppShadows {
  static const List<BoxShadow> none = [];

  static final List<BoxShadow> small = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      offset: const Offset(0, 1),
      blurRadius: 3.0,
      spreadRadius: 0.0,
    ),
  ];

  static final List<BoxShadow> medium = [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      offset: const Offset(0, 2),
      blurRadius: 8.0,
      spreadRadius: 0.0,
    ),
  ];

  static final List<BoxShadow> large = [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      offset: const Offset(0, 4),
      blurRadius: 16.0,
      spreadRadius: 0.0,
    ),
  ];

  // Component mappings
  static final List<BoxShadow> card = none; // Use border instead of shadow per design rules
  static final List<BoxShadow> resultOverlay = medium;
  static final List<BoxShadow> toolbar = large;
  static final List<BoxShadow> fab = large;
}
