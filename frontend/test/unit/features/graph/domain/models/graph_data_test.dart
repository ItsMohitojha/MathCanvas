import 'package:flutter_test/flutter_test.dart';
import 'package:mathcanvas/features/graph/domain/models/graph_data.dart';

void main() {
  group('GraphData', () {
    late GraphData sampleGraph;

    setUp(() {
      sampleGraph = GraphData(
        id: 'test-graph-id',
        expressionId: 'test-expr-id',
        variable: 'x',
        xRangeMin: -5.0,
        xRangeMax: 5.0,
        numPoints: 5,
        xValues: [-5.0, -2.5, 0.0, 2.5, 5.0],
        yValues: [25.0, 6.25, 0.0, 6.25, 25.0],
        title: 'y = x²',
        color: '#6366f1',
        generatedAt: DateTime(2026, 6, 26),
      );
    });

    test('yMin returns minimum non-null y value', () {
      expect(sampleGraph.yMin, 0.0);
    });

    test('yMax returns maximum non-null y value', () {
      expect(sampleGraph.yMax, 25.0);
    });

    test('hasData returns true when y-values contain non-null entries', () {
      expect(sampleGraph.hasData, isTrue);
    });

    test('hasData returns false when all y-values are null', () {
      final emptyGraph = sampleGraph.copyWith(
        yValues: [null, null, null, null, null],
      );
      expect(emptyGraph.hasData, isFalse);
    });

    test('yMin returns null when all y-values are null', () {
      final emptyGraph = sampleGraph.copyWith(
        yValues: [null, null, null, null, null],
      );
      expect(emptyGraph.yMin, isNull);
    });

    test('yMax returns null when all y-values are null', () {
      final emptyGraph = sampleGraph.copyWith(
        yValues: [null, null, null, null, null],
      );
      expect(emptyGraph.yMax, isNull);
    });

    test('handles mixed null and non-null y-values', () {
      final mixedGraph = sampleGraph.copyWith(
        yValues: [null, 3.0, null, 7.0, null],
      );
      expect(mixedGraph.yMin, 3.0);
      expect(mixedGraph.yMax, 7.0);
      expect(mixedGraph.hasData, isTrue);
    });

    test('copyWith creates a modified copy', () {
      final modified = sampleGraph.copyWith(
        title: 'Modified Title',
        xRangeMin: -20.0,
      );
      expect(modified.title, 'Modified Title');
      expect(modified.xRangeMin, -20.0);
      expect(modified.id, sampleGraph.id); // unchanged
    });

    test('JSON round-trip preserves data', () {
      final json = sampleGraph.toJson();
      final restored = GraphData.fromJson(json);
      expect(restored.id, sampleGraph.id);
      expect(restored.expressionId, sampleGraph.expressionId);
      expect(restored.variable, sampleGraph.variable);
      expect(restored.xRangeMin, sampleGraph.xRangeMin);
      expect(restored.xRangeMax, sampleGraph.xRangeMax);
      expect(restored.numPoints, sampleGraph.numPoints);
      expect(restored.xValues, sampleGraph.xValues);
      expect(restored.yValues, sampleGraph.yValues);
      expect(restored.title, sampleGraph.title);
      expect(restored.color, sampleGraph.color);
    });

    test('default values are applied', () {
      final minimal = GraphData(
        id: 'id',
        expressionId: 'eid',
        xValues: [0.0],
        yValues: [0.0],
        title: 'test',
        generatedAt: DateTime.now(),
      );
      expect(minimal.variable, 'x');
      expect(minimal.xRangeMin, -10.0);
      expect(minimal.xRangeMax, 10.0);
      expect(minimal.numPoints, 500);
      expect(minimal.color, '#6366f1');
    });

    test('yMin and yMax with single data point', () {
      final single = sampleGraph.copyWith(
        xValues: [0.0],
        yValues: [42.0],
      );
      expect(single.yMin, 42.0);
      expect(single.yMax, 42.0);
    });

    test('negative y-values are handled correctly', () {
      final negGraph = sampleGraph.copyWith(
        yValues: [-10.0, -5.0, -1.0, -5.0, -10.0],
      );
      expect(negGraph.yMin, -10.0);
      expect(negGraph.yMax, -1.0);
    });
  });
}
