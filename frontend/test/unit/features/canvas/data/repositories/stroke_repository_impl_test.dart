import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mathcanvas/features/canvas/data/datasources/stroke_local_datasource.dart';
import 'package:mathcanvas/features/canvas/data/models/stroke_entity.dart';
import 'package:mathcanvas/features/canvas/data/repositories/stroke_repository_impl.dart';
import 'package:mathcanvas/features/canvas/domain/models/stroke.dart';
import 'package:mathcanvas/features/canvas/domain/models/stroke_point.dart';

class FakeStrokeLocalDatasource implements StrokeLocalDatasource {
  final List<StrokeEntity> database = [];

  @override
  Future<void> insertStroke(StrokeEntity stroke) async {
    database.removeWhere((e) => e.id == stroke.id);
    database.add(stroke);
  }

  @override
  Future<void> insertStrokeBatch(List<StrokeEntity> strokes) async {
    for (final s in strokes) {
      await insertStroke(s);
    }
  }

  @override
  Future<void> deleteStroke(String id) async {
    database.removeWhere((e) => e.id == id);
  }

  @override
  Future<List<StrokeEntity>> getStrokesByNotebookId(String notebookId) async {
    return database.where((e) => e.notebookId == notebookId).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  @override
  Future<List<StrokeEntity>> getStrokesInViewport(
    String notebookId,
    Rect viewport,
  ) async {
    return database.where((e) {
      if (e.notebookId != notebookId) return false;
      final strokeRect =
          Rect.fromLTRB(e.bboxMinX, e.bboxMinY, e.bboxMaxX, e.bboxMaxY);
      return strokeRect.overlaps(viewport);
    }).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }
}

void main() {
  group('StrokeRepositoryImpl', () {
    late FakeStrokeLocalDatasource fakeDatasource;
    late StrokeRepositoryImpl repository;

    setUp(() {
      fakeDatasource = FakeStrokeLocalDatasource();
      repository = StrokeRepositoryImpl(fakeDatasource);
    });

    final testStroke = Stroke(
      id: 'stroke-1',
      notebookId: 'notebook-1',
      points: const [
        StrokePoint(x: 10, y: 20, timestamp: 100, pressure: 0.5),
        StrokePoint(x: 15, y: 25, timestamp: 110, pressure: 0.7),
      ],
      color: '#1e293b',
      strokeWidth: 3.0,
      createdAt: DateTime.utc(2026, 6, 18),
    );

    test('saveStroke_addsStrokeToDatasource', () async {
      await repository.saveStroke(testStroke);

      expect(fakeDatasource.database.length, 1);
      final entity = fakeDatasource.database.first;
      expect(entity.id, 'stroke-1');
      expect(entity.color, '#1e293b');
      expect(entity.bboxMinX, 10);
      expect(entity.bboxMinY, 20);
      expect(entity.bboxMaxX, 15);
      expect(entity.bboxMaxY, 25);
    });

    test('saveStrokes_addsAllStrokesToDatasource', () async {
      final secondStroke = testStroke.copyWith(id: 'stroke-2');
      await repository.saveStrokes([testStroke, secondStroke]);

      expect(fakeDatasource.database.length, 2);
    });

    test('deleteStroke_removesStrokeFromDatasource', () async {
      await repository.saveStroke(testStroke);
      expect(fakeDatasource.database.length, 1);

      await repository.deleteStroke('stroke-1');
      expect(fakeDatasource.database, isEmpty);
    });

    test('getStrokes_returnsDomainStrokesFromDatasource', () async {
      await repository.saveStroke(testStroke);

      final strokes = await repository.getStrokes('notebook-1');
      expect(strokes.length, 1);
      expect(strokes.first.id, 'stroke-1');
      expect(strokes.first.points.length, 2);
      expect(strokes.first.points[0].x, 10);
      expect(strokes.first.points[1].y, 25);
    });

    test('getStrokesInViewport_returnsOnlyOverlappingStrokes', () async {
      final insideStroke = testStroke; // bbox [10, 20, 15, 25]
      final outsideStroke = testStroke.copyWith(
        id: 'stroke-2',
        points: const [
          StrokePoint(x: 100, y: 100, timestamp: 200, pressure: 1.0),
          StrokePoint(x: 110, y: 110, timestamp: 210, pressure: 1.0),
        ],
      ); // bbox [100, 100, 110, 110]

      await repository.saveStrokes([insideStroke, outsideStroke]);

      final viewport = const Rect.fromLTRB(0, 0, 50, 50);
      final culledStrokes =
          await repository.getStrokesInViewport('notebook-1', viewport);

      expect(culledStrokes.length, 1);
      expect(culledStrokes.first.id, 'stroke-1');
    });
  });
}
