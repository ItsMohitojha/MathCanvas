// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graph_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GraphDataImpl _$$GraphDataImplFromJson(Map<String, dynamic> json) =>
    _$GraphDataImpl(
      id: json['id'] as String,
      expressionId: json['expressionId'] as String,
      variable: json['variable'] as String? ?? 'x',
      xRangeMin: (json['xRangeMin'] as num?)?.toDouble() ?? -10.0,
      xRangeMax: (json['xRangeMax'] as num?)?.toDouble() ?? 10.0,
      numPoints: (json['numPoints'] as num?)?.toInt() ?? 500,
      xValues: (json['xValues'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      yValues: (json['yValues'] as List<dynamic>)
          .map((e) => (e as num?)?.toDouble())
          .toList(),
      title: json['title'] as String,
      color: json['color'] as String? ?? '#6366f1',
      generatedAt: DateTime.parse(json['generatedAt'] as String),
    );

Map<String, dynamic> _$$GraphDataImplToJson(_$GraphDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'expressionId': instance.expressionId,
      'variable': instance.variable,
      'xRangeMin': instance.xRangeMin,
      'xRangeMax': instance.xRangeMax,
      'numPoints': instance.numPoints,
      'xValues': instance.xValues,
      'yValues': instance.yValues,
      'title': instance.title,
      'color': instance.color,
      'generatedAt': instance.generatedAt.toIso8601String(),
    };
