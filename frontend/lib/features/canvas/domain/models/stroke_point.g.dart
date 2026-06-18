// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stroke_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StrokePointImpl _$$StrokePointImplFromJson(Map<String, dynamic> json) =>
    _$StrokePointImpl(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      timestamp: (json['timestamp'] as num).toInt(),
      pressure: (json['pressure'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$$StrokePointImplToJson(_$StrokePointImpl instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'timestamp': instance.timestamp,
      'pressure': instance.pressure,
    };
