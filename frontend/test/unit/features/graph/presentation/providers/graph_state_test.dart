import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mathcanvas/features/graph/domain/models/graph_data.dart';
import 'package:mathcanvas/features/graph/presentation/providers/graph_state.dart';

void main() {
  group('GraphState', () {
    test('default state has empty graphs and no error', () {
      const state = GraphState();
      expect(state.graphs, isEmpty);
      expect(state.isPending, isFalse);
      expect(state.error, isNull);
    });

    test('copyWith updates graphs map', () {
      const state = GraphState();
      final graph = GraphData(
        id: 'g1',
        expressionId: 'e1',
        xValues: [0.0, 1.0],
        yValues: [0.0, 1.0],
        title: 'y = x',
        generatedAt: DateTime(2026, 6, 26),
      );
      final updated = state.copyWith(graphs: {'e1': graph});
      expect(updated.graphs.length, 1);
      expect(updated.graphs['e1']?.title, 'y = x');
    });

    test('copyWith updates isPending', () {
      const state = GraphState();
      final updated = state.copyWith(isPending: true);
      expect(updated.isPending, isTrue);
    });

    test('copyWith updates error', () {
      const state = GraphState();
      final updated = state.copyWith(error: 'Something failed');
      expect(updated.error, 'Something failed');
    });

    test('clearing error resets it to null', () {
      final stateWithError = const GraphState().copyWith(error: 'err');
      final cleared = stateWithError.copyWith(error: null);
      expect(cleared.error, isNull);
    });

    test('multiple graphs can coexist', () {
      final g1 = GraphData(
        id: 'g1',
        expressionId: 'e1',
        xValues: [0.0],
        yValues: [0.0],
        title: 'Graph 1',
        generatedAt: DateTime.now(),
      );
      final g2 = GraphData(
        id: 'g2',
        expressionId: 'e2',
        xValues: [1.0],
        yValues: [1.0],
        title: 'Graph 2',
        generatedAt: DateTime.now(),
      );
      final state = GraphState(graphs: {'e1': g1, 'e2': g2});
      expect(state.graphs.length, 2);
      expect(state.graphs['e1']?.title, 'Graph 1');
      expect(state.graphs['e2']?.title, 'Graph 2');
    });

    test('JSON round-trip preserves state', () {
      final graph = GraphData(
        id: 'g1',
        expressionId: 'e1',
        xValues: [0.0, 1.0, 2.0],
        yValues: [0.0, 1.0, 4.0],
        title: 'y = x²',
        generatedAt: DateTime(2026, 6, 26),
      );
      final state = GraphState(graphs: {'e1': graph});
      // Use jsonEncode/jsonDecode for a true deep serialization cycle
      final jsonString = jsonEncode(state.toJson());
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      final restored = GraphState.fromJson(decoded);
      expect(restored.graphs.length, 1);
      expect(restored.graphs['e1']?.title, 'y = x²');
      expect(restored.isPending, isFalse);
      expect(restored.error, isNull);
    });
  });
}
