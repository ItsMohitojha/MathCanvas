// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recognized_expression.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecognizedExpressionImpl _$$RecognizedExpressionImplFromJson(
        Map<String, dynamic> json) =>
    _$RecognizedExpressionImpl(
      id: json['id'] as String,
      notebookId: json['notebookId'] as String,
      rawLatex: json['rawLatex'] as String,
      parsedExpression: json['parsedExpression'] as String?,
      expressionType: json['expressionType'] as String? ?? 'unknown',
      confidence: (json['confidence'] as num).toDouble(),
      bboxMinX: (json['bboxMinX'] as num).toDouble(),
      bboxMinY: (json['bboxMinY'] as num).toDouble(),
      bboxMaxX: (json['bboxMaxX'] as num).toDouble(),
      bboxMaxY: (json['bboxMaxY'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      strokeIds:
          (json['strokeIds'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$RecognizedExpressionImplToJson(
        _$RecognizedExpressionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notebookId': instance.notebookId,
      'rawLatex': instance.rawLatex,
      'parsedExpression': instance.parsedExpression,
      'expressionType': instance.expressionType,
      'confidence': instance.confidence,
      'bboxMinX': instance.bboxMinX,
      'bboxMinY': instance.bboxMinY,
      'bboxMaxX': instance.bboxMaxX,
      'bboxMaxY': instance.bboxMaxY,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'strokeIds': instance.strokeIds,
    };
