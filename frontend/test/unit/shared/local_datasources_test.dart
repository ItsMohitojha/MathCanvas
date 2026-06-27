import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:mathcanvas/shared/database/database_migrations.dart';
import 'package:mathcanvas/features/notebook/data/datasources/notebook_local_datasource.dart';
import 'package:mathcanvas/features/notebook/data/models/notebook_entity.dart';
import 'package:mathcanvas/features/canvas/data/datasources/stroke_local_datasource.dart';
import 'package:mathcanvas/features/canvas/data/models/stroke_entity.dart';
import 'package:mathcanvas/features/recognition/data/datasources/expression_local_datasource.dart';
import 'package:mathcanvas/features/recognition/data/models/expression_entity.dart';
import 'package:mathcanvas/features/math_engine/data/datasources/math_local_datasource.dart';
import 'package:mathcanvas/features/math_engine/data/models/result_entity.dart';
import 'package:mathcanvas/features/math_engine/data/models/variable_entity.dart';
import 'package:mathcanvas/features/graph/data/datasources/graph_local_datasource.dart';
import 'package:mathcanvas/features/graph/data/models/graph_entity.dart';

void main() {
  // Initialize ffi for in-memory SQLite
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('SQLite Local Datasources Integration Tests', () {
    late Database db;
    late NotebookLocalDatasource notebookDatasource;
    late StrokeLocalDatasource strokeDatasource;
    late ExpressionLocalDatasource expressionDatasource;
    late MathLocalDatasource mathDatasource;
    late GraphLocalDatasource graphDatasource;

    setUp(() async {
      db = await openDatabase(
        inMemoryDatabasePath,
        version: DatabaseMigrations.currentVersion,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON;');
        },
        onCreate: (db, version) async {
          await DatabaseMigrations.migrate(db, 0, version);
        },
      );

      final Future<Database> dbFuture = Future.value(db);
      notebookDatasource = NotebookLocalDatasourceImpl(dbFuture);
      strokeDatasource = StrokeLocalDatasourceImpl(dbFuture);
      expressionDatasource = ExpressionLocalDatasourceImpl(dbFuture);
      mathDatasource = MathLocalDatasourceImpl(dbFuture);
      graphDatasource = GraphLocalDatasourceImpl(dbFuture);
    });

    tearDown(() async {
      await db.close();
    });

    test('NotebookLocalDatasource CRUD', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      final nb = NotebookEntity(
        id: 'nb_1',
        name: 'My Notebook',
        createdAt: now,
        updatedAt: now,
        viewportX: 10.0,
        viewportY: 20.0,
        zoomLevel: 1.5,
      );

      // Insert & query
      await notebookDatasource.insertNotebook(nb);
      final list = await notebookDatasource.getNotebooks();
      expect(list.length, equals(1));
      expect(list.first.name, equals('My Notebook'));

      // Query by ID
      final retrieved = await notebookDatasource.getNotebookById('nb_1');
      expect(retrieved, isNotNull);
      expect(retrieved!.viewportX, equals(10.0));

      // Rename
      await notebookDatasource.renameNotebook('nb_1', 'New Name', now + 1000);
      final renamed = await notebookDatasource.getNotebookById('nb_1');
      expect(renamed!.name, equals('New Name'));

      // Update viewport
      await notebookDatasource.updateViewport('nb_1', 50.0, 60.0, 2.0, now + 2000);
      final updated = await notebookDatasource.getNotebookById('nb_1');
      expect(updated!.zoomLevel, equals(2.0));
      expect(updated.viewportX, equals(50.0));

      // Delete
      await notebookDatasource.deleteNotebook('nb_1');
      final listAfter = await notebookDatasource.getNotebooks();
      expect(listAfter.isEmpty, isTrue);
    });

    test('StrokeLocalDatasource CRUD', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      final nb = NotebookEntity(
        id: 'nb_2',
        name: 'Stroke Notebook',
        createdAt: now,
        updatedAt: now,
        viewportX: 0.0,
        viewportY: 0.0,
        zoomLevel: 1.0,
      );
      await notebookDatasource.insertNotebook(nb);

      final stroke = StrokeEntity(
        id: 's_1',
        notebookId: 'nb_2',
        pointsJson: '[{"x":10.0,"y":10.0,"t":100,"p":1.0}]',
        color: '#ff0000',
        strokeWidth: 3.0,
        createdAt: now,
        bboxMinX: 5.0,
        bboxMinY: 5.0,
        bboxMaxX: 15.0,
        bboxMaxY: 15.0,
      );

      // Save & query
      await strokeDatasource.insertStroke(stroke);
      final strokes = await strokeDatasource.getStrokesByNotebookId('nb_2');
      expect(strokes.length, equals(1));
      expect(strokes.first.color, equals('#ff0000'));

      // Query in viewport
      final inViewport = await strokeDatasource.getStrokesInViewport(
        'nb_2',
        const Rect.fromLTRB(0.0, 0.0, 20.0, 20.0),
      );
      expect(inViewport.length, equals(1));

      // Out of viewport query
      final outViewport = await strokeDatasource.getStrokesInViewport(
        'nb_2',
        const Rect.fromLTRB(50.0, 50.0, 100.0, 100.0),
      );
      expect(outViewport.isEmpty, isTrue);

      // Delete
      await strokeDatasource.deleteStroke('s_1');
      final strokesAfter = await strokeDatasource.getStrokesByNotebookId('nb_2');
      expect(strokesAfter.isEmpty, isTrue);
    });

    test('ExpressionLocalDatasource CRUD', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      final nb = NotebookEntity(
        id: 'nb_3',
        name: 'Expr Notebook',
        createdAt: now,
        updatedAt: now,
        viewportX: 0.0,
        viewportY: 0.0,
        zoomLevel: 1.0,
      );
      await notebookDatasource.insertNotebook(nb);

      // Pre-insert strokes to satisfy foreign key constraints
      final s1 = StrokeEntity(
        id: 's_1',
        notebookId: 'nb_3',
        pointsJson: '[]',
        color: '#000000',
        strokeWidth: 2.0,
        createdAt: now,
        bboxMinX: 0, bboxMinY: 0, bboxMaxX: 0, bboxMaxY: 0,
      );
      final s2 = StrokeEntity(
        id: 's_2',
        notebookId: 'nb_3',
        pointsJson: '[]',
        color: '#000000',
        strokeWidth: 2.0,
        createdAt: now,
        bboxMinX: 0, bboxMinY: 0, bboxMaxX: 0, bboxMaxY: 0,
      );
      final s3 = StrokeEntity(
        id: 's_3',
        notebookId: 'nb_3',
        pointsJson: '[]',
        color: '#000000',
        strokeWidth: 2.0,
        createdAt: now,
        bboxMinX: 0, bboxMinY: 0, bboxMaxX: 0, bboxMaxY: 0,
      );
      await strokeDatasource.insertStroke(s1);
      await strokeDatasource.insertStroke(s2);
      await strokeDatasource.insertStroke(s3);

      final expr = ExpressionEntity(
        id: 'e_1',
        notebookId: 'nb_3',
        rawLatex: 'y = x + 1',
        parsedExpression: 'y - x - 1',
        expressionType: 'function',
        confidence: 0.95,
        bboxMinX: 0.0,
        bboxMinY: 0.0,
        bboxMaxX: 100.0,
        bboxMaxY: 50.0,
        createdAt: now,
        updatedAt: now,
      );

      // Save & query
      await expressionDatasource.saveExpression(expr, ['s_1', 's_2']);
      final list = await expressionDatasource.getExpressions('nb_3');
      expect(list.length, equals(1));
      expect(list.first.rawLatex, equals('y = x + 1'));

      final strokeIds = await expressionDatasource.getStrokeIdsForExpression('e_1');
      expect(strokeIds, equals(['s_1', 's_2']));

      // Replace expressions
      final expr2 = ExpressionEntity(
        id: 'e_2',
        notebookId: 'nb_3',
        rawLatex: 'a = 5',
        expressionType: 'assignment',
        confidence: 0.9,
        bboxMinX: 0.0,
        bboxMinY: 60.0,
        bboxMaxX: 100.0,
        bboxMaxY: 110.0,
        createdAt: now,
        updatedAt: now,
      );
      await expressionDatasource.replaceExpressions('nb_3', [expr2], [['s_3']]);

      final replacedList = await expressionDatasource.getExpressions('nb_3');
      expect(replacedList.length, equals(1));
      expect(replacedList.first.id, equals('e_2'));

      // Delete
      await expressionDatasource.deleteExpression('e_2');
      final listAfter = await expressionDatasource.getExpressions('nb_3');
      expect(listAfter.isEmpty, isTrue);
    });

    test('MathLocalDatasource CRUD', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      final nb = NotebookEntity(
        id: 'nb_4',
        name: 'Math Notebook',
        createdAt: now,
        updatedAt: now,
        viewportX: 0.0,
        viewportY: 0.0,
        zoomLevel: 1.0,
      );
      await notebookDatasource.insertNotebook(nb);

      final s1 = StrokeEntity(
        id: 's_1',
        notebookId: 'nb_4',
        pointsJson: '[]',
        color: '#000000',
        strokeWidth: 2.0,
        createdAt: now,
        bboxMinX: 0, bboxMinY: 0, bboxMaxX: 0, bboxMaxY: 0,
      );
      await strokeDatasource.insertStroke(s1);

      final expr = ExpressionEntity(
        id: 'e_3',
        notebookId: 'nb_4',
        rawLatex: 'a = 10',
        expressionType: 'assignment',
        confidence: 1.0,
        bboxMinX: 0.0,
        bboxMinY: 0.0,
        bboxMaxX: 50.0,
        bboxMaxY: 50.0,
        createdAt: now,
        updatedAt: now,
      );
      await expressionDatasource.saveExpression(expr, ['s_1']);

      final result = ResultEntity(
        id: 'r_1',
        expressionId: 'e_3',
        resultType: 'numeric',
        value: '10',
        latex: '10',
        numericValue: 10.0,
        computedAt: now,
      );

      final variable = VariableEntity(
        id: 'v_1',
        notebookId: 'nb_4',
        name: 'a',
        value: '10',
        expressionId: 'e_3',
        updatedAt: now,
      );

      // Save
      await mathDatasource.saveResult(result);
      await mathDatasource.saveVariable(variable);

      // Query
      final results = await mathDatasource.getResults('nb_4');
      final variables = await mathDatasource.getVariables('nb_4');

      expect(results.length, equals(1));
      expect(results.first.value, equals('10'));
      expect(variables.length, equals(1));
      expect(variables.first.name, equals('a'));

      // Replace results and variables
      final result2 = ResultEntity(
        id: 'r_2',
        expressionId: 'e_3',
        resultType: 'numeric',
        value: '20',
        latex: '20',
        numericValue: 20.0,
        computedAt: now + 1000,
      );
      final variable2 = VariableEntity(
        id: 'v_2',
        notebookId: 'nb_4',
        name: 'b',
        value: '20',
        expressionId: 'e_3',
        updatedAt: now + 1000,
      );
      await mathDatasource.replaceResultsAndVariables(
        notebookId: 'nb_4',
        results: [result2],
        variables: [variable2],
      );

      final resultsAfter = await mathDatasource.getResults('nb_4');
      final variablesAfter = await mathDatasource.getVariables('nb_4');
      expect(resultsAfter.first.value, equals('20'));
      expect(variablesAfter.first.name, equals('b'));

      // Delete
      await mathDatasource.deleteResult('e_3');
      await mathDatasource.deleteVariable('b', 'nb_4');
      expect((await mathDatasource.getResults('nb_4')).isEmpty, isTrue);
      expect((await mathDatasource.getVariables('nb_4')).isEmpty, isTrue);
    });

    test('GraphLocalDatasource CRUD', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      final nb = NotebookEntity(
        id: 'nb_5',
        name: 'Graph Notebook',
        createdAt: now,
        updatedAt: now,
        viewportX: 0.0,
        viewportY: 0.0,
        zoomLevel: 1.0,
      );
      await notebookDatasource.insertNotebook(nb);

      final s1 = StrokeEntity(
        id: 's_1',
        notebookId: 'nb_5',
        pointsJson: '[]',
        color: '#000000',
        strokeWidth: 2.0,
        createdAt: now,
        bboxMinX: 0, bboxMinY: 0, bboxMaxX: 0, bboxMaxY: 0,
      );
      await strokeDatasource.insertStroke(s1);

      final expr = ExpressionEntity(
        id: 'e_4',
        notebookId: 'nb_5',
        rawLatex: 'y = x^2',
        expressionType: 'function',
        confidence: 1.0,
        bboxMinX: 0.0,
        bboxMinY: 0.0,
        bboxMaxX: 50.0,
        bboxMaxY: 50.0,
        createdAt: now,
        updatedAt: now,
      );
      await expressionDatasource.saveExpression(expr, ['s_1']);

      final graph = GraphEntity(
        id: 'g_1',
        expressionId: 'e_4',
        graphDataJson: '{"x":[1,2],"y":[1,4]}',
        variable: 'x',
        xRangeMin: -5.0,
        xRangeMax: 5.0,
        numPoints: 2,
        generatedAt: now,
      );

      // Save & Query
      await graphDatasource.saveGraph(graph);
      final retrieved = await graphDatasource.getGraphByExpressionId('e_4');
      expect(retrieved, isNotNull);
      expect(retrieved!.xRangeMin, equals(-5.0));

      final list = await graphDatasource.getGraphs('nb_5');
      expect(list.length, equals(1));

      // Delete Graph
      await graphDatasource.deleteGraph('e_4');
      expect(await graphDatasource.getGraphByExpressionId('e_4'), isNull);

      // Re-save & delete all for notebook
      await graphDatasource.saveGraph(graph);
      await graphDatasource.deleteAllGraphs('nb_5');
      expect(await graphDatasource.getGraphs('nb_5'), isEmpty);
    });
  });
}
