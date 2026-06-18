/// Coordinate transformation utilities for the canvas.
///
/// Provides pure functions to convert between screen-space and
/// world-space coordinates using the viewport offset and zoom level.
/// All methods are stateless for easy testing.
library;

import 'dart:ui';

import 'package:vector_math/vector_math_64.dart';

/// Pure utility for canvas coordinate transformations.
///
/// Converts between screen-space (pixel) and world-space (logical)
/// coordinates based on the current viewport offset and zoom level.
class CanvasTransform {
  /// Creates a transform from the given [offset] and [zoom].
  const CanvasTransform({
    required this.offset,
    required this.zoom,
  });

  /// The current viewport offset in world coordinates.
  final Offset offset;

  /// The current zoom level.
  final double zoom;

  /// Builds a 4×4 transformation matrix for the canvas.
  ///
  /// The matrix applies translation (pan) followed by scaling (zoom).
  /// This is used by [CustomPaint] to transform the canvas coordinate
  /// system from world-space to screen-space.
  Matrix4 get transformMatrix {
    return Matrix4.identity()
      ..scaleByVector3(Vector3(zoom, zoom, 1.0))
      ..translateByVector3(Vector3(offset.dx, offset.dy, 0.0));
  }

  /// Converts a screen-space [point] to world coordinates.
  ///
  /// Reverses the zoom and pan transformations to find the
  /// corresponding position in the infinite canvas world.
  Offset screenToWorld(Offset point) {
    return Offset(
      point.dx / zoom - offset.dx,
      point.dy / zoom - offset.dy,
    );
  }

  /// Converts a world-space [point] to screen coordinates.
  ///
  /// Applies zoom and pan transformations to find the pixel
  /// position on screen for a given world-space point.
  Offset worldToScreen(Offset point) {
    return Offset(
      (point.dx + offset.dx) * zoom,
      (point.dy + offset.dy) * zoom,
    );
  }

  /// Calculates the visible world-coordinate rectangle.
  ///
  /// Given the [screenSize], returns the axis-aligned bounding box in
  /// world coordinates that is currently visible on screen. Includes
  /// an optional [margin] (in world units) for viewport culling.
  Rect visibleWorldRect(Size screenSize, {double margin = 0}) {
    final topLeft = screenToWorld(Offset.zero);
    final bottomRight = screenToWorld(
      Offset(screenSize.width, screenSize.height),
    );
    return Rect.fromLTRB(
      topLeft.dx - margin,
      topLeft.dy - margin,
      bottomRight.dx + margin,
      bottomRight.dy + margin,
    );
  }
}
