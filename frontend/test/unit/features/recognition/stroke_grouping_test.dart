import 'package:flutter_test/flutter_test.dart';
import 'package:mathcanvas/features/canvas/domain/models/stroke.dart';
import 'package:mathcanvas/features/canvas/domain/models/stroke_point.dart';
import 'package:mathcanvas/features/recognition/presentation/providers/recognition_state_provider.dart';

void main() {
  group('Stroke Grouping Algorithm Tests', () {
    Stroke createStroke({
      required String id,
      required double minX,
      required double minY,
      required double maxX,
      required double maxY,
    }) {
      return Stroke(
        id: id,
        notebookId: 'test-notebook',
        createdAt: DateTime.now(),
        points: [
          StrokePoint(x: minX, y: minY, timestamp: 0, pressure: 1.0),
          StrokePoint(x: maxX, y: maxY, timestamp: 0, pressure: 1.0),
        ],
      );
    }

    test('should group overlapping strokes together', () {
      final s1 = createStroke(id: 's1', minX: 10, minY: 10, maxX: 20, maxY: 20);
      final s2 = createStroke(id: 's2', minX: 15, minY: 15, maxX: 25, maxY: 25);

      final notifier = RecognitionStateNotifier();
      final groups = notifier.groupStrokes([s1, s2], 50.0);

      expect(groups.length, equals(1));
      expect(groups.first.map((s) => s.id), containsAll(['s1', 's2']));
    });

    test('should group strokes that are close (within groupingThreshold) together', () {
      final s1 = createStroke(id: 's1', minX: 10, minY: 10, maxX: 20, maxY: 20);
      final s2 = createStroke(id: 's2', minX: 40, minY: 10, maxX: 50, maxY: 20);

      final notifier = RecognitionStateNotifier();
      final groups = notifier.groupStrokes([s1, s2], 50.0);

      expect(groups.length, equals(1));
      expect(groups.first.map((s) => s.id), containsAll(['s1', 's2']));
    });

    test('should separate strokes that are far apart', () {
      final s1 = createStroke(id: 's1', minX: 10, minY: 10, maxX: 20, maxY: 20);
      final s2 = createStroke(id: 's2', minX: 95, minY: 10, maxX: 105, maxY: 20);

      final notifier = RecognitionStateNotifier();
      final groups = notifier.groupStrokes([s1, s2], 50.0);

      expect(groups.length, equals(2));
      expect(groups[0].first.id, equals('s1'));
      expect(groups[1].first.id, equals('s2'));
    });
  });
}
