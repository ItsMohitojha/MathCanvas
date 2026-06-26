import 'dart:ui';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recognized_expression.freezed.dart';
part 'recognized_expression.g.dart';

/// Immutable domain model representing a recognized mathematical expression.
@freezed
class RecognizedExpression with _$RecognizedExpression {
  /// Creates a [RecognizedExpression].
  const factory RecognizedExpression({
    required String id,
    required String notebookId,
    required String rawLatex,
    String? parsedExpression,
    @Default('unknown') String expressionType,
    required double confidence,
    required double bboxMinX,
    required double bboxMinY,
    required double bboxMaxX,
    required double bboxMaxY,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<String> strokeIds,
  }) = _RecognizedExpression;

  const RecognizedExpression._();

  /// Creates a [RecognizedExpression] from a JSON map.
  factory RecognizedExpression.fromJson(Map<String, dynamic> json) =>
      _$RecognizedExpressionFromJson(json);

  /// Bounding box representation in world coordinates.
  Rect get boundingBox => Rect.fromLTRB(bboxMinX, bboxMinY, bboxMaxX, bboxMaxY);
}
