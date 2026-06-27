import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mathcanvas/features/canvas/domain/repositories/stroke_repository.dart';
import 'package:mathcanvas/features/canvas/presentation/providers/canvas_state_provider.dart';
import 'package:mathcanvas/features/canvas/domain/models/stroke.dart';
import 'package:mathcanvas/features/canvas/domain/models/stroke_point.dart';
import 'package:mathcanvas/features/recognition/domain/models/recognized_expression.dart';
import 'package:mathcanvas/features/recognition/domain/repositories/expression_repository.dart';
import 'package:mathcanvas/features/recognition/data/models/expression_entity.dart';
import 'package:mathcanvas/features/recognition/data/datasources/expression_local_datasource.dart';
import 'package:mathcanvas/features/recognition/presentation/providers/recognition_state_provider.dart';
import 'package:mathcanvas/features/recognition/data/engines/tflite_recognition_engine.dart';
import 'package:mathcanvas/features/notebook/domain/repositories/notebook_repository.dart';
import 'package:mathcanvas/features/notebook/domain/models/notebook.dart';
import 'package:mathcanvas/features/notebook/presentation/providers/notebook_state_provider.dart';

class FakeNotebookRepository implements NotebookRepository {
  @override
  Future<List<Notebook>> getNotebooks() async => [];
  @override
  Future<Notebook?> getNotebookById(String id) async => null;
  @override
  Future<Notebook> createNotebook(String name) async => throw UnimplementedError();
  @override
  Future<void> renameNotebook(String id, String name) async {}
  @override
  Future<void> deleteNotebook(String id) async {}
  @override
  Future<void> updateViewport(String id, double x, double y, double zoom) async {}
}

// Fake expression datasource to run without real sqflite in tests
class FakeExpressionLocalDatasource implements ExpressionLocalDatasource {
  final List<ExpressionEntity> expressions = [];
  final Map<String, List<String>> expressionStrokes = {};

  @override
  Future<List<ExpressionEntity>> getExpressions(String notebookId) async {
    return expressions.where((e) => e.notebookId == notebookId).toList();
  }

  @override
  Future<List<String>> getStrokeIdsForExpression(String expressionId) async {
    return expressionStrokes[expressionId] ?? [];
  }

  @override
  Future<void> saveExpression(ExpressionEntity expression, List<String> strokeIds) async {
    expressions.removeWhere((e) => e.id == expression.id);
    expressions.add(expression);
    expressionStrokes[expression.id] = strokeIds;
  }

  @override
  Future<void> deleteExpression(String id) async {
    expressions.removeWhere((e) => e.id == id);
    expressionStrokes.remove(id);
  }

  @override
  Future<void> replaceExpressions(
    String notebookId,
    List<ExpressionEntity> newExpressions,
    List<List<String>> strokeIdsList,
  ) async {
    expressions.removeWhere((e) => e.notebookId == notebookId);
    for (int i = 0; i < newExpressions.length; i++) {
      final expr = newExpressions[i];
      final strokeIds = strokeIdsList[i];
      expressions.add(expr);
      expressionStrokes[expr.id] = strokeIds;
    }
  }
}

// Fake stroke repository to run without real sqflite in tests
class FakeStrokeRepository implements StrokeRepository {
  final List<Stroke> database = [];

  @override
  Future<void> saveStroke(Stroke stroke) async {
    database.removeWhere((s) => s.id == stroke.id);
    database.add(stroke);
  }

  @override
  Future<void> saveStrokes(List<Stroke> strokes) async {
    for (final s in strokes) {
      await saveStroke(s);
    }
  }

  @override
  Future<void> deleteStroke(String id) async {
    database.removeWhere((s) => s.id == id);
  }

  @override
  Future<List<Stroke>> getStrokes(String notebookId) async {
    return database.where((s) => s.notebookId == notebookId).toList();
  }

  @override
  Future<List<Stroke>> getStrokesInViewport(String notebookId, Rect viewport) async {
    return database.where((s) => s.notebookId == notebookId && s.boundingBox.overlaps(viewport)).toList();
  }
}

void main() {
  group('Recognition Pipeline Integration Tests', () {
    late FakeExpressionLocalDatasource fakeExprDatasource;
    late FakeStrokeRepository fakeStrokeRepo;

    setUp(() {
      fakeExprDatasource = FakeExpressionLocalDatasource();
      fakeStrokeRepo = FakeStrokeRepository();
      TFLiteRecognitionEngine.clearMockResults();
    });

    test('should run grouping and recognition when strokes are added to canvas', () async {
      final container = ProviderContainer(
        overrides: [
          expressionLocalDatasourceProvider.overrideWithValue(fakeExprDatasource),
          strokeRepositoryProvider.overrideWithValue(fakeStrokeRepo),
          notebookRepositoryProvider.overrideWithValue(FakeNotebookRepository()),
        ],
      );

      // Initialize active notebook
      final canvasNotifier = container.read(canvasStateProvider.notifier);
      await canvasNotifier.loadNotebook('test-notebook');

      // Register a mock recognition result for a stroke ID
      TFLiteRecognitionEngine.registerMockResult('s1', '1');

      // Simulate drawing a vertical stroke
      canvasNotifier.startStroke(const Offset(10, 10), 0, 1.0);
      canvasNotifier.updateStroke(const Offset(10, 20), 5, 1.0);
      canvasNotifier.updateStroke(const Offset(10, 50), 10, 1.0);

      // Complete the stroke
      await canvasNotifier.endStroke(const Offset(10, 50), 10, 1.0);

      final strokes = container.read(canvasStateProvider).strokes;
      expect(strokes.length, equals(1));

      // Overwrite the random stroke ID to 's1' to match the test registry
      final savedStroke = strokes.first.copyWith(id: 's1');

      // Execute recognition pipeline
      final recognitionNotifier = container.read(recognitionStateProvider.notifier);
      await recognitionNotifier.runRecognition('test-notebook', [savedStroke]);

      // Assert Riverpod State
      final recState = container.read(recognitionStateProvider);
      expect(recState.expressions.length, equals(1));
      expect(recState.expressions.first.rawLatex, equals('1'));
      expect(recState.expressions.first.strokeIds, contains('s1'));

      // Assert Database CRUD
      final repository = container.read(expressionRepositoryProvider);
      final dbExpressions = await repository.getExpressions('test-notebook');
      expect(dbExpressions.length, equals(1));
      expect(dbExpressions.first.rawLatex, equals('1'));
      expect(dbExpressions.first.strokeIds, contains('s1'));
    });
  });
}
