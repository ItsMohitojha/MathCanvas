import 'package:mathcanvas/features/canvas/domain/models/stroke.dart';
import '../models/recognition_result.dart';

/// Abstract contract for a math handwriting recognition engine.
abstract class RecognitionEngine {
  /// Initializes the engine (loads models, templates, etc.).
  Future<void> initialize();

  /// Recognizes math symbols from a list of strokes.
  Future<List<RecognitionResult>> recognize(List<Stroke> strokes);

  /// Releases resources.
  Future<void> dispose();
}
