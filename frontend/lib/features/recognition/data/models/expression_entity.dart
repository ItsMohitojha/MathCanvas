import 'package:mathcanvas/features/recognition/domain/models/recognized_expression.dart';

/// Database Transfer Object for the expressions table.
class ExpressionEntity {
  final String id;
  final String notebookId;
  final String rawLatex;
  final String? parsedExpression;
  final String expressionType;
  final double confidence;
  final double bboxMinX;
  final double bboxMinY;
  final double bboxMaxX;
  final double bboxMaxY;
  final int createdAt;
  final int updatedAt;

  /// Creates an [ExpressionEntity].
  ExpressionEntity({
    required this.id,
    required this.notebookId,
    required this.rawLatex,
    this.parsedExpression,
    required this.expressionType,
    required this.confidence,
    required this.bboxMinX,
    required this.bboxMinY,
    required this.bboxMaxX,
    required this.bboxMaxY,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Converts this entity to a map for database insertion.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'notebook_id': notebookId,
      'raw_latex': rawLatex,
      'parsed_expression': parsedExpression,
      'expression_type': expressionType,
      'confidence': confidence,
      'bbox_min_x': bboxMinX,
      'bbox_min_y': bboxMinY,
      'bbox_max_x': bboxMaxX,
      'bbox_max_y': bboxMaxY,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Creates an [ExpressionEntity] from a database map.
  factory ExpressionEntity.fromMap(Map<String, dynamic> map) {
    return ExpressionEntity(
      id: map['id'] as String,
      notebookId: map['notebook_id'] as String,
      rawLatex: map['raw_latex'] as String,
      parsedExpression: map['parsed_expression'] as String?,
      expressionType: map['expression_type'] as String,
      confidence: (map['confidence'] as num).toDouble(),
      bboxMinX: (map['bbox_min_x'] as num).toDouble(),
      bboxMinY: (map['bbox_min_y'] as num).toDouble(),
      bboxMaxX: (map['bbox_max_x'] as num).toDouble(),
      bboxMaxY: (map['bbox_max_y'] as num).toDouble(),
      createdAt: map['created_at'] as int,
      updatedAt: map['updated_at'] as int,
    );
  }

  /// Converts this entity to a domain model.
  RecognizedExpression toDomain(List<String> strokeIds) {
    return RecognizedExpression(
      id: id,
      notebookId: notebookId,
      rawLatex: rawLatex,
      parsedExpression: parsedExpression,
      expressionType: expressionType,
      confidence: confidence,
      bboxMinX: bboxMinX,
      bboxMinY: bboxMinY,
      bboxMaxX: bboxMaxX,
      bboxMaxY: bboxMaxY,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
      strokeIds: strokeIds,
    );
  }

  /// Creates an [ExpressionEntity] from a domain model.
  factory ExpressionEntity.fromDomain(RecognizedExpression domain) {
    return ExpressionEntity(
      id: domain.id,
      notebookId: domain.notebookId,
      rawLatex: domain.rawLatex,
      parsedExpression: domain.parsedExpression,
      expressionType: domain.expressionType,
      confidence: domain.confidence,
      bboxMinX: domain.bboxMinX,
      bboxMinY: domain.bboxMinY,
      bboxMaxX: domain.bboxMaxX,
      bboxMaxY: domain.bboxMaxY,
      createdAt: domain.createdAt.millisecondsSinceEpoch,
      updatedAt: domain.updatedAt.millisecondsSinceEpoch,
    );
  }
}
