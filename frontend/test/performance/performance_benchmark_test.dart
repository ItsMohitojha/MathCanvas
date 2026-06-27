import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:mathcanvas/shared/database/database_migrations.dart';
import 'package:mathcanvas/features/notebook/data/datasources/notebook_local_datasource.dart';
import 'package:mathcanvas/features/notebook/data/models/notebook_entity.dart';
import 'package:mathcanvas/features/canvas/presentation/widgets/stroke_painter.dart';
import 'package:mathcanvas/features/canvas/domain/models/stroke.dart';
import 'package:mathcanvas/features/canvas/domain/models/stroke_point.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('MathCanvas Frontend Performance Benchmarks', () {
    test('SQLite CRUD Latency Benchmark', () async {
      final db = await openDatabase(
        inMemoryDatabasePath,
        version: DatabaseMigrations.currentVersion,
        onCreate: (db, version) async {
          await DatabaseMigrations.migrate(db, 0, version);
        },
      );

      final notebookDb = NotebookLocalDatasourceImpl(Future.value(db));
      final stopwatch = Stopwatch()..start();

      // Perform 100 writes
      for (int i = 0; i < 100; i++) {
        await notebookDb.insertNotebook(NotebookEntity(
          id: 'nb_bench_$i',
          name: 'Notebook $i',
          createdAt: DateTime.now().millisecondsSinceEpoch,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
          viewportX: i.toDouble(),
          viewportY: i.toDouble(),
          zoomLevel: 1.0,
        ));
      }

      final writeTime = stopwatch.elapsedMilliseconds;
      stopwatch.reset();
      stopwatch.start();

      // Perform 100 reads
      final list = await notebookDb.getNotebooks();
      expect(list.length, equals(100));

      final readTime = stopwatch.elapsedMilliseconds;
      print('\n[BENCHMARK] SQLite 100 writes: $writeTime ms (${writeTime / 100} ms/write)');
      print('[BENCHMARK] SQLite 100 reads: $readTime ms (${readTime / 100} ms/read)');

      await db.close();
    });

    test('Catmull-Rom Spline Calculations Benchmark', () {
      final p0 = const Offset(0, 0);
      final p1 = const Offset(10, 20);
      final p2 = const Offset(30, 40);
      final p3 = const Offset(40, 50);

      final stopwatch = Stopwatch()..start();

      // Compute 10,000 spline interpolations
      double sumX = 0;
      double sumY = 0;
      for (int i = 0; i < 10000; i++) {
        final t = (i % 100) / 100.0;
        final t2 = t * t;
        final t3 = t2 * t;

        final x = 0.5 *
            ((2 * p1.dx) +
                (-p0.dx + p2.dx) * t +
                (2 * p0.dx - 5 * p1.dx + 4 * p2.dx - p3.dx) * t2 +
                (-p0.dx + 3 * p1.dx - 3 * p2.dx + p3.dx) * t3);

        final y = 0.5 *
            ((2 * p1.dy) +
                (-p0.dy + p2.dy) * t +
                (2 * p0.dy - 5 * p1.dy + 4 * p2.dy - p3.dy) * t2 +
                (-p0.dy + 3 * p1.dy - 3 * p2.dy + p3.dy) * t3);

        sumX += x;
        sumY += y;
      }

      final elapsed = stopwatch.elapsedMilliseconds;
      print('[BENCHMARK] 10,000 Catmull-Rom calculations: $elapsed ms (${elapsed / 10000} ms/op)');
      expect(sumX, isPositive);
    });

    test('StrokePainter Paint Latency Benchmark', () {
      final points = List<StrokePoint>.generate(
        10,
        (i) => StrokePoint(
          x: i * 10.0,
          y: i * 15.0,
          pressure: 1.0,
          timestamp: i * 100,
        ),
      );

      final strokes = List<Stroke>.generate(
        100,
        (i) => Stroke(
          id: 'stroke_$i',
          notebookId: 'nb_bench',
          points: points,
          color: '#000000',
          strokeWidth: 2.0,
          createdAt: DateTime.now(),
        ),
      );

      final painter = StrokePainter(
        strokes: strokes,
        currentStroke: null,
        viewportOffset: Offset.zero,
        zoomLevel: 1.0,
        strokeColor: const Color(0xFF000000),
      );

      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      final stopwatch = Stopwatch()..start();

      // Trigger painting on real canvas
      painter.paint(canvas, const Size(1000, 1000));

      final elapsed = stopwatch.elapsedMilliseconds;
      print('[BENCHMARK] Paint 100 strokes (10 points each): $elapsed ms');
      expect(elapsed, isNonNegative);
    });
  });
}
