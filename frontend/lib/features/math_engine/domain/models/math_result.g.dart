// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'math_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MathResultImpl _$$MathResultImplFromJson(Map<String, dynamic> json) =>
    _$MathResultImpl(
      id: json['id'] as String,
      expressionId: json['expressionId'] as String,
      resultType: json['resultType'] as String,
      value: json['value'] as String,
      latex: json['latex'] as String,
      numericValue: (json['numericValue'] as num?)?.toDouble(),
      computedAt: DateTime.parse(json['computedAt'] as String),
    );

Map<String, dynamic> _$$MathResultImplToJson(_$MathResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'expressionId': instance.expressionId,
      'resultType': instance.resultType,
      'value': instance.value,
      'latex': instance.latex,
      'numericValue': instance.numericValue,
      'computedAt': instance.computedAt.toIso8601String(),
    };
