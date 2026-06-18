/// Stroke database entity model.
///
/// Handles mapping and serialization between the domain [Stroke] model
/// and SQLite database columns in the `strokes` table.
library;

import 'dart:convert';

import 'package:mathcanvas/features/canvas/domain/models/stroke.dart';
import 'package:mathcanvas/features/canvas/domain/models/stroke_point.dart';

/// Database representation of a stroke.
class StrokeEntity {
  /// Unique stroke identifier (UUID v4).
  final String id;

  /// ID of the notebook this stroke belongs to.
  final String notebookId;

  /// JSON serialized list of points.
  final String pointsJson;

  /// Hex color string (e.g. #1E293B).
  final String color;

  /// Base stroke width in logical pixels.
  final double strokeWidth;

  /// Stroke creation timestamp in Unix milliseconds.
  final int createdAt;

  /// Minimum X bound (world coordinates).
  final double bboxMinX;

  /// Minimum Y bound (world coordinates).
  final double bboxMinY;

  /// Maximum X bound (world coordinates).
  final double bboxMaxX;

  /// Maximum Y bound (world coordinates).
  final double bboxMaxY;

  /// Creates a [StrokeEntity].
  const StrokeEntity({
    required this.id,
    required this.notebookId,
    required this.pointsJson,
    required this.color,
    required this.strokeWidth,
    required this.createdAt,
    required this.bboxMinX,
    required this.bboxMinY,
    required this.bboxMaxX,
    required this.bboxMaxY,
  });

  /// Maps a domain [Stroke] to a [StrokeEntity].
  factory StrokeEntity.fromDomain(Stroke stroke) {
    final bbox = stroke.boundingBox;
    final pointsList = stroke.points
        .map((p) => {
              'x': p.x,
              'y': p.y,
              't': p.timestamp,
              'p': p.pressure,
            })
        .toList();

    return StrokeEntity(
      id: stroke.id,
      notebookId: stroke.notebookId,
      pointsJson: jsonEncode(pointsList),
      color: stroke.color,
      strokeWidth: stroke.strokeWidth,
      createdAt: stroke.createdAt.millisecondsSinceEpoch,
      bboxMinX: bbox.left,
      bboxMinY: bbox.top,
      bboxMaxX: bbox.right,
      bboxMaxY: bbox.bottom,
    );
  }

  /// Maps this [StrokeEntity] back to a domain [Stroke].
  Stroke toDomain() {
    final List<dynamic> decoded = jsonDecode(pointsJson);
    final points = decoded
        .map((p) => StrokePoint(
              x: (p['x'] as num).toDouble(),
              y: (p['y'] as num).toDouble(),
              timestamp: p['t'] as int,
              pressure: (p['p'] as num?)?.toDouble() ?? 1.0,
            ))
        .toList();

    return Stroke(
      id: id,
      notebookId: notebookId,
      points: points,
      color: color,
      strokeWidth: strokeWidth,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
    );
  }

  /// Converts this entity to a map suitable for database insertion.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'notebook_id': notebookId,
      'points_json': pointsJson,
      'color': color,
      'stroke_width': strokeWidth,
      'created_at': createdAt,
      'bbox_min_x': bboxMinX,
      'bbox_min_y': bboxMinY,
      'bbox_max_x': bboxMaxX,
      'bbox_max_y': bboxMaxY,
    };
  }

  /// Creates a [StrokeEntity] from a database row map.
  factory StrokeEntity.fromMap(Map<String, dynamic> map) {
    return StrokeEntity(
      id: map['id'] as String,
      notebookId: map['notebook_id'] as String,
      pointsJson: map['points_json'] as String,
      color: map['color'] as String,
      strokeWidth: (map['stroke_width'] as num).toDouble(),
      createdAt: map['created_at'] as int,
      bboxMinX: (map['bbox_min_x'] as num).toDouble(),
      bboxMinY: (map['bbox_min_y'] as num).toDouble(),
      bboxMaxX: (map['bbox_max_x'] as num).toDouble(),
      bboxMaxY: (map['bbox_max_y'] as num).toDouble(),
    );
  }
}
