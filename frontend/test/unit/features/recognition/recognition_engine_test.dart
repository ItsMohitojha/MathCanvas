import 'package:flutter_test/flutter_test.dart';
import 'package:mathcanvas/features/canvas/domain/models/stroke.dart';
import 'package:mathcanvas/features/canvas/domain/models/stroke_point.dart';
import 'package:mathcanvas/features/recognition/data/engines/tflite_recognition_engine.dart';

void main() {
  group('TFLiteRecognitionEngine Heuristics Tests', () {
    late TFLiteRecognitionEngine engine;

    setUp(() {
      engine = TFLiteRecognitionEngine();
      TFLiteRecognitionEngine.clearMockResults();
    });

    test('should classify horizontal stroke as minus (-)', () async {
      final minusStroke = Stroke(
        id: 's1',
        notebookId: 'notebook',
        createdAt: DateTime.now(),
        points: [
          StrokePoint(x: 10, y: 10, timestamp: 0, pressure: 1.0),
          StrokePoint(x: 50, y: 10, timestamp: 10, pressure: 1.0),
        ],
      );

      final results = await engine.recognize([minusStroke]);
      expect(results.length, equals(1));
      expect(results.first.latex, equals('-'));
    });

    test('should classify vertical stroke as one (1)', () async {
      final oneStroke = Stroke(
        id: 's1',
        notebookId: 'notebook',
        createdAt: DateTime.now(),
        points: [
          StrokePoint(x: 10, y: 10, timestamp: 0, pressure: 1.0),
          StrokePoint(x: 10, y: 50, timestamp: 10, pressure: 1.0),
        ],
      );

      final results = await engine.recognize([oneStroke]);
      expect(results.length, equals(1));
      expect(results.first.latex, equals('1'));
    });

    test('should classify two intersecting perpendicular strokes as plus (+)', () async {
      final horizontal = Stroke(
        id: 's1',
        notebookId: 'notebook',
        createdAt: DateTime.now(),
        points: [
          StrokePoint(x: 10, y: 30, timestamp: 0, pressure: 1.0),
          StrokePoint(x: 50, y: 30, timestamp: 10, pressure: 1.0),
        ],
      );
      final vertical = Stroke(
        id: 's2',
        notebookId: 'notebook',
        createdAt: DateTime.now(),
        points: [
          StrokePoint(x: 30, y: 10, timestamp: 0, pressure: 1.0),
          StrokePoint(x: 30, y: 50, timestamp: 10, pressure: 1.0),
        ],
      );

      final results = await engine.recognize([horizontal, vertical]);
      expect(results.length, equals(1));
      expect(results.first.latex, equals('+'));
    });

    test('should classify two parallel horizontal strokes as equals (=)', () async {
      final top = Stroke(
        id: 's1',
        notebookId: 'notebook',
        createdAt: DateTime.now(),
        points: [
          StrokePoint(x: 10, y: 20, timestamp: 0, pressure: 1.0),
          StrokePoint(x: 50, y: 20, timestamp: 10, pressure: 1.0),
        ],
      );
      final bottom = Stroke(
        id: 's2',
        notebookId: 'notebook',
        createdAt: DateTime.now(),
        points: [
          StrokePoint(x: 10, y: 30, timestamp: 0, pressure: 1.0),
          StrokePoint(x: 50, y: 30, timestamp: 10, pressure: 1.0),
        ],
      );

      final results = await engine.recognize([top, bottom]);
      expect(results.length, equals(1));
      expect(results.first.latex, equals('='));
    });

    test('should use test registry for mock output when matched', () async {
      TFLiteRecognitionEngine.registerMockResult('s1,s2', '2x');

      final s1 = Stroke(
        id: 's1',
        notebookId: 'notebook',
        createdAt: DateTime.now(),
        points: [StrokePoint(x: 0, y: 0, timestamp: 0, pressure: 1.0)],
      );
      final s2 = Stroke(
        id: 's2',
        notebookId: 'notebook',
        createdAt: DateTime.now(),
        points: [StrokePoint(x: 10, y: 10, timestamp: 0, pressure: 1.0)],
      );

      final results = await engine.recognize([s1, s2]);
      expect(results.length, equals(1));
      expect(results.first.latex, equals('2x'));
      expect(results.first.confidence, equals(0.99));
    });

    test('should detect exponent (superscript) when character is raised', () async {
      final s1 = Stroke(
        id: 's1',
        notebookId: 'notebook',
        createdAt: DateTime.now(),
        points: [
          StrokePoint(x: 10, y: 20, timestamp: 0, pressure: 1.0),
          StrokePoint(x: 30, y: 40, timestamp: 0, pressure: 1.0),
        ],
      );

      final s2 = Stroke(
        id: 's2',
        notebookId: 'notebook',
        createdAt: DateTime.now(),
        points: [
          StrokePoint(x: 35, y: 5, timestamp: 0, pressure: 1.0),
          StrokePoint(x: 38, y: 15, timestamp: 0, pressure: 1.0),
        ],
      );

      final results = await engine.recognize([s1, s2]);
      expect(results.length, equals(1));
      expect(results.first.latex, contains('^{1}'));
    });
  });
}
