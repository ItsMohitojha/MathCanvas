// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notebook_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotebookStateImpl _$$NotebookStateImplFromJson(Map<String, dynamic> json) =>
    _$NotebookStateImpl(
      notebooks: (json['notebooks'] as List<dynamic>?)
              ?.map((e) => Notebook.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Notebook>[],
      activeNotebook: json['activeNotebook'] == null
          ? null
          : Notebook.fromJson(json['activeNotebook'] as Map<String, dynamic>),
      isPending: json['isPending'] as bool? ?? false,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$NotebookStateImplToJson(_$NotebookStateImpl instance) =>
    <String, dynamic>{
      'notebooks': instance.notebooks,
      'activeNotebook': instance.activeNotebook,
      'isPending': instance.isPending,
      'error': instance.error,
    };
