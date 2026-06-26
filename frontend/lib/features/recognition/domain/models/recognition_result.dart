import 'dart:ui';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recognition_result.freezed.dart';

/// Bounding box and LaTeX expression result for a single grouped set of strokes.
@freezed
class RecognitionResult with _$RecognitionResult {
  const factory RecognitionResult({
    required String latex,
    required double confidence,
    required Rect boundingBox,
    required List<String> strokeIds,
  }) = _RecognitionResult;
}
