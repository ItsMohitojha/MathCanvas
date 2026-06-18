/// Stroke domain model.
///
/// Represents a single continuous hand-drawn stroke, composed of a
/// list of points, visual properties (color, width), and creation metadata.
library;

import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'stroke_point.dart';

part 'stroke.freezed.dart';
part 'stroke.g.dart';

/// A single continuous path drawn by the user on the canvas.
///
/// Encapsulates the points list and metadata for SQLite persistence.
@freezed
class Stroke with _$Stroke {
  /// Creates a [Stroke].
  @JsonSerializable(explicitToJson: true)
  const factory Stroke({
    required String id,
    required String notebookId,
    required List<StrokePoint> points,
    @Default('#1E293B') String color,
    @Default(2.0) double strokeWidth,
    required DateTime createdAt,
  }) = _Stroke;

  const Stroke._();

  /// Creates a [Stroke] from a JSON map.
  factory Stroke.fromJson(Map<String, dynamic> json) =>
      _$StrokeFromJson(json);

  /// Calculates the bounding box of this stroke in world coordinates.
  ///
  /// Returns [Rect.zero] if the stroke is empty. Used for viewport culling
  /// and spatial queries.
  Rect get boundingBox {
    if (points.isEmpty) return Rect.zero;

    double minX = points.first.x;
    double minY = points.first.y;
    double maxX = points.first.x;
    double maxY = points.first.y;

    for (final p in points) {
      if (p.x < minX) minX = p.x;
      if (p.y < minY) minY = p.y;
      if (p.x > maxX) maxX = p.x;
      if (p.y > maxY) maxY = p.y;
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }
}
