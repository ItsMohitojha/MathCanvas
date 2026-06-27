// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'math_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MathStateImpl _$$MathStateImplFromJson(Map<String, dynamic> json) =>
    _$MathStateImpl(
      results: (json['results'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, MathResult.fromJson(e as Map<String, dynamic>)),
          ) ??
          const <String, MathResult>{},
      symbolTable: (json['symbolTable'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      dependencies: (json['dependencies'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, (e as List<dynamic>).map((e) => e as String).toSet()),
          ) ??
          const <String, Set<String>>{},
      definedVariables:
          (json['definedVariables'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, e as String),
              ) ??
              const <String, String>{},
      isPending: json['isPending'] as bool? ?? false,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$MathStateImplToJson(_$MathStateImpl instance) =>
    <String, dynamic>{
      'results': instance.results,
      'symbolTable': instance.symbolTable,
      'dependencies':
          instance.dependencies.map((k, e) => MapEntry(k, e.toList())),
      'definedVariables': instance.definedVariables,
      'isPending': instance.isPending,
      'error': instance.error,
    };
