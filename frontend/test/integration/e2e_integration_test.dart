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
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('MathCanvas End-to-End Integration Flow', () {
    late Database db;
    late NotebookLocalDatasource notebookDb;
    late StrokeLocalDatasource strokeDb;
    late ExpressionLocalDatasource exprDb;
    late MathLocalDatasource mathDb;
    late GraphLocalDatasource graphDb;

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
      notebookDb = NotebookLocalDatasourceImpl(dbFuture);
      strokeDb = StrokeLocalDatasourceImpl(dbFuture);
      exprDb = ExpressionLocalDatasourceImpl(dbFuture);
      mathDb = MathLocalDatasourceImpl(dbFuture);
      graphDb = GraphLocalDatasourceImpl(dbFuture);
    });

    tearDown(() async {
      await db.close();
    });

    test('Create notebook -> draw strokes -> recognize expression -> evaluate math -> generate graph', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      final notebookId = 'nb_e2e';

      // 1. Create a new notebook
      await notebookDb.insertNotebook(NotebookEntity(
        id: notebookId,
        name: 'E2E Test Notebook',
        createdAt: now,
        updatedAt: now,
        viewportX: 0.0,
        viewportY: 0.0,
        zoomLevel: 1.0,
      ));

      // 2. Draw stroke 's1' representing y = x
      final stroke = StrokeEntity(
        id: 's_e2e_1',
        notebookId: notebookId,
        pointsJson: '[{"x":10.0,"y":20.0,"t":100,"p":1.0},{"x":30.0,"y":40.0,"t":200,"p":1.0}]',
        color: '#000000',
        strokeWidth: 2.0,
        createdAt: now,
        bboxMinX: 10.0,
        bboxMinY: 20.0,
        bboxMaxX: 30.0,
        bboxMaxY: 40.0,
      );
      await strokeDb.insertStroke(stroke);

      // Verify stroke is saved
      final savedStrokes = await strokeDb.getStrokesByNotebookId(notebookId);
      expect(savedStrokes.length, equals(1));
      expect(savedStrokes.first.id, equals('s_e2e_1'));

      // 3. Handwriting Recognition Pipeline: Save recognized expression 'e_e2e_1'
      final expr = ExpressionEntity(
        id: 'e_e2e_1',
        notebookId: notebookId,
        rawLatex: 'y = x',
        parsedExpression: 'y - x',
        expressionType: 'function',
        confidence: 0.98,
        bboxMinX: 10.0,
        bboxMinY: 20.0,
        bboxMaxX: 30.0,
        bboxMaxY: 40.0,
        createdAt: now,
        updatedAt: now,
      );
      await exprDb.saveExpression(expr, ['s_e2e_1']);

      // Verify expression is saved and mapped to stroke
      final savedExprs = await exprDb.getExpressions(notebookId);
      expect(savedExprs.length, equals(1));
      expect(savedExprs.first.rawLatex, equals('y = x'));

      final mappedStrokes = await exprDb.getStrokeIdsForExpression('e_e2e_1');
      expect(mappedStrokes, equals(['s_e2e_1']));

      // 4. Math Engine: Save computed result and declare variable
      final result = ResultEntity(
        id: 'res_e2e_1',
        expressionId: 'e_e2e_1',
        resultType: 'numeric',
        value: '5.0',
        latex: '5.0',
        numericValue: 5.0,
        computedAt: now,
      );
      final variable = VariableEntity(
        id: 'v_e2e_1',
        notebookId: notebookId,
        name: 'y',
        value: '5.0',
        expressionId: 'e_e2e_1',
        updatedAt: now,
      );

      await mathDb.saveResult(result);
      await mathDb.saveVariable(variable);

      // Verify math result and variable exist
      final savedResults = await mathDb.getResults(notebookId);
      expect(savedResults.length, equals(1));
      expect(savedResults.first.value, equals('5.0'));

      final savedVars = await mathDb.getVariables(notebookId);
      expect(savedVars.length, equals(1));
      expect(savedVars.first.name, equals('y'));

      // 5. Graph Engine: Generate and save graph coordinates
      final graph = GraphEntity(
        id: 'g_e2e_1',
        expressionId: 'e_e2e_1',
        graphDataJson: '{"x":[1.0, 2.0, 3.0],"y":[1.0, 2.0, 3.0]}',
        variable: 'x',
        xRangeMin: -10.0,
        xRangeMax: 10.0,
        numPoints: 3,
        generatedAt: now,
      );
      await graphDb.saveGraph(graph);

      // Verify graph data
      final savedGraphs = await graphDb.getGraphs(notebookId);
      expect(savedGraphs.length, equals(1));
      expect(savedGraphs.first.numPoints, equals(3));
      
      final retrievedGraph = await graphDb.getGraphByExpressionId('e_e2e_1');
      expect(retrievedGraph, isNotNull);
      expect(retrievedGraph!.expressionId, equals('e_e2e_1'));
    });
  });
}
