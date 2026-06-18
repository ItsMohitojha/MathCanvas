/// Stroke point domain model.
///
/// Represents a single recorded point along a continuous stroke,
/// containing world-space coordinates, timestamp, and stylus pressure.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'stroke_point.freezed.dart';
part 'stroke_point.g.dart';

/// An individual touch/stylus point within a stroke.
///
/// Coordinates are in world units. [pressure] defaults to 1.0.
@freezed
class StrokePoint with _$StrokePoint {
  /// Creates a [StrokePoint].
  const factory StrokePoint({
    required double x,
    required double y,
    required int timestamp,
    @Default(1.0) double pressure,
  }) = _StrokePoint;

  /// Creates a [StrokePoint] from a JSON map.
  factory StrokePoint.fromJson(Map<String, dynamic> json) =>
      _$StrokePointFromJson(json);
}
