// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graph_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GraphStateImpl _$$GraphStateImplFromJson(Map<String, dynamic> json) =>
    _$GraphStateImpl(
      graphs: (json['graphs'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, GraphData.fromJson(e as Map<String, dynamic>)),
          ) ??
          const <String, GraphData>{},
      isPending: json['isPending'] as bool? ?? false,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$GraphStateImplToJson(_$GraphStateImpl instance) =>
    <String, dynamic>{
      'graphs': instance.graphs,
      'isPending': instance.isPending,
      'error': instance.error,
    };
