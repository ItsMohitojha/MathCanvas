// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stroke.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StrokeImpl _$$StrokeImplFromJson(Map<String, dynamic> json) => _$StrokeImpl(
      id: json['id'] as String,
      notebookId: json['notebookId'] as String,
      points: (json['points'] as List<dynamic>)
          .map((e) => StrokePoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      color: json['color'] as String? ?? '#1E293B',
      strokeWidth: (json['strokeWidth'] as num?)?.toDouble() ?? 2.0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$StrokeImplToJson(_$StrokeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notebookId': instance.notebookId,
      'points': instance.points.map((e) => e.toJson()).toList(),
      'color': instance.color,
      'strokeWidth': instance.strokeWidth,
      'createdAt': instance.createdAt.toIso8601String(),
    };
