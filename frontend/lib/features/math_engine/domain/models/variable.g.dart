// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VariableImpl _$$VariableImplFromJson(Map<String, dynamic> json) =>
    _$VariableImpl(
      id: json['id'] as String,
      notebookId: json['notebookId'] as String,
      name: json['name'] as String,
      value: json['value'] as String,
      expressionId: json['expressionId'] as String?,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$VariableImplToJson(_$VariableImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notebookId': instance.notebookId,
      'name': instance.name,
      'value': instance.value,
      'expressionId': instance.expressionId,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
