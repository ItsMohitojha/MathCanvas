// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notebook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotebookImpl _$$NotebookImplFromJson(Map<String, dynamic> json) =>
    _$NotebookImpl(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Untitled Notebook',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      viewportX: (json['viewportX'] as num?)?.toDouble() ?? 0.0,
      viewportY: (json['viewportY'] as num?)?.toDouble() ?? 0.0,
      zoomLevel: (json['zoomLevel'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$$NotebookImplToJson(_$NotebookImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'viewportX': instance.viewportX,
      'viewportY': instance.viewportY,
      'zoomLevel': instance.zoomLevel,
    };
