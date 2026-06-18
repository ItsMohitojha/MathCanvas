import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mathcanvas/features/canvas/domain/models/stroke.dart';
import 'package:mathcanvas/features/canvas/domain/models/stroke_point.dart';

void main() {
  group('Stroke', () {
    test('boundingBox_withEmptyPoints_returnsZero', () {
      final stroke = Stroke(
        id: 'test-id',
        notebookId: 'notebook-id',
        points: const [],
        createdAt: DateTime.now(),
      );

      expect(stroke.boundingBox, Rect.zero);
    });

    test('boundingBox_withSinglePoint_returnsZeroWidthAndHeightRect', () {
      final stroke = Stroke(
        id: 'test-id',
        notebookId: 'notebook-id',
        points: const [
          StrokePoint(x: 10, y: 20, timestamp: 0, pressure: 1.0),
        ],
        createdAt: DateTime.now(),
      );

      expect(stroke.boundingBox.left, 10);
      expect(stroke.boundingBox.top, 20);
      expect(stroke.boundingBox.right, 10);
      expect(stroke.boundingBox.bottom, 20);
      expect(stroke.boundingBox.width, 0);
      expect(stroke.boundingBox.height, 0);
    });

    test('boundingBox_withMultiplePoints_calculatesCorrectBounds', () {
      final stroke = Stroke(
        id: 'test-id',
        notebookId: 'notebook-id',
        points: const [
          StrokePoint(x: 10, y: 40, timestamp: 0, pressure: 1.0),
          StrokePoint(x: 30, y: 20, timestamp: 1, pressure: 1.0),
          StrokePoint(x: 20, y: 30, timestamp: 2, pressure: 1.0),
        ],
        color: '#000000',
        strokeWidth: 2.0,
        createdAt: DateTime.now(),
      );

      expect(stroke.boundingBox.left, 10);
      expect(stroke.boundingBox.top, 20);
      expect(stroke.boundingBox.right, 30);
      expect(stroke.boundingBox.bottom, 40);
      expect(stroke.boundingBox.width, 20);
      expect(stroke.boundingBox.height, 20);
    });

    test('fromJson_andToJson_serializationLoopback', () {
      final original = Stroke(
        id: 'test-id',
        notebookId: 'notebook-id',
        points: const [
          StrokePoint(x: 10, y: 20, timestamp: 0, pressure: 0.8),
        ],
        color: '#ff0000',
        strokeWidth: 4.5,
        createdAt: DateTime.utc(2026, 6, 18, 12, 0, 0),
      );

      final json = original.toJson();
      final reconstructed = Stroke.fromJson(json);

      expect(reconstructed.id, original.id);
      expect(reconstructed.notebookId, original.notebookId);
      expect(reconstructed.points.length, 1);
      expect(reconstructed.points.first.x, 10);
      expect(reconstructed.points.first.y, 20);
      expect(reconstructed.points.first.pressure, 0.8);
      expect(reconstructed.color, '#ff0000');
      expect(reconstructed.strokeWidth, 4.5);
      expect(reconstructed.createdAt, original.createdAt);
    });
  });
}
