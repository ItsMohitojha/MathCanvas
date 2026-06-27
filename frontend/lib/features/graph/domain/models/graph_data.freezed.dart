// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'graph_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GraphData _$GraphDataFromJson(Map<String, dynamic> json) {
  return _GraphData.fromJson(json);
}

/// @nodoc
mixin _$GraphData {
  String get id => throw _privateConstructorUsedError;
  String get expressionId => throw _privateConstructorUsedError;
  String get variable => throw _privateConstructorUsedError;
  double get xRangeMin => throw _privateConstructorUsedError;
  double get xRangeMax => throw _privateConstructorUsedError;
  int get numPoints => throw _privateConstructorUsedError;
  List<double> get xValues => throw _privateConstructorUsedError;
  List<double?> get yValues => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  DateTime get generatedAt => throw _privateConstructorUsedError;

  /// Serializes this GraphData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GraphData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GraphDataCopyWith<GraphData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GraphDataCopyWith<$Res> {
  factory $GraphDataCopyWith(GraphData value, $Res Function(GraphData) then) =
      _$GraphDataCopyWithImpl<$Res, GraphData>;
  @useResult
  $Res call(
      {String id,
      String expressionId,
      String variable,
      double xRangeMin,
      double xRangeMax,
      int numPoints,
      List<double> xValues,
      List<double?> yValues,
      String title,
      String color,
      DateTime generatedAt});
}

/// @nodoc
class _$GraphDataCopyWithImpl<$Res, $Val extends GraphData>
    implements $GraphDataCopyWith<$Res> {
  _$GraphDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GraphData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? expressionId = null,
    Object? variable = null,
    Object? xRangeMin = null,
    Object? xRangeMax = null,
    Object? numPoints = null,
    Object? xValues = null,
    Object? yValues = null,
    Object? title = null,
    Object? color = null,
    Object? generatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      expressionId: null == expressionId
          ? _value.expressionId
          : expressionId // ignore: cast_nullable_to_non_nullable
              as String,
      variable: null == variable
          ? _value.variable
          : variable // ignore: cast_nullable_to_non_nullable
              as String,
      xRangeMin: null == xRangeMin
          ? _value.xRangeMin
          : xRangeMin // ignore: cast_nullable_to_non_nullable
              as double,
      xRangeMax: null == xRangeMax
          ? _value.xRangeMax
          : xRangeMax // ignore: cast_nullable_to_non_nullable
              as double,
      numPoints: null == numPoints
          ? _value.numPoints
          : numPoints // ignore: cast_nullable_to_non_nullable
              as int,
      xValues: null == xValues
          ? _value.xValues
          : xValues // ignore: cast_nullable_to_non_nullable
              as List<double>,
      yValues: null == yValues
          ? _value.yValues
          : yValues // ignore: cast_nullable_to_non_nullable
              as List<double?>,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GraphDataImplCopyWith<$Res>
    implements $GraphDataCopyWith<$Res> {
  factory _$$GraphDataImplCopyWith(
          _$GraphDataImpl value, $Res Function(_$GraphDataImpl) then) =
      __$$GraphDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String expressionId,
      String variable,
      double xRangeMin,
      double xRangeMax,
      int numPoints,
      List<double> xValues,
      List<double?> yValues,
      String title,
      String color,
      DateTime generatedAt});
}

/// @nodoc
class __$$GraphDataImplCopyWithImpl<$Res>
    extends _$GraphDataCopyWithImpl<$Res, _$GraphDataImpl>
    implements _$$GraphDataImplCopyWith<$Res> {
  __$$GraphDataImplCopyWithImpl(
      _$GraphDataImpl _value, $Res Function(_$GraphDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of GraphData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? expressionId = null,
    Object? variable = null,
    Object? xRangeMin = null,
    Object? xRangeMax = null,
    Object? numPoints = null,
    Object? xValues = null,
    Object? yValues = null,
    Object? title = null,
    Object? color = null,
    Object? generatedAt = null,
  }) {
    return _then(_$GraphDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      expressionId: null == expressionId
          ? _value.expressionId
          : expressionId // ignore: cast_nullable_to_non_nullable
              as String,
      variable: null == variable
          ? _value.variable
          : variable // ignore: cast_nullable_to_non_nullable
              as String,
      xRangeMin: null == xRangeMin
          ? _value.xRangeMin
          : xRangeMin // ignore: cast_nullable_to_non_nullable
              as double,
      xRangeMax: null == xRangeMax
          ? _value.xRangeMax
          : xRangeMax // ignore: cast_nullable_to_non_nullable
              as double,
      numPoints: null == numPoints
          ? _value.numPoints
          : numPoints // ignore: cast_nullable_to_non_nullable
              as int,
      xValues: null == xValues
          ? _value._xValues
          : xValues // ignore: cast_nullable_to_non_nullable
              as List<double>,
      yValues: null == yValues
          ? _value._yValues
          : yValues // ignore: cast_nullable_to_non_nullable
              as List<double?>,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GraphDataImpl extends _GraphData {
  const _$GraphDataImpl(
      {required this.id,
      required this.expressionId,
      this.variable = 'x',
      this.xRangeMin = -10.0,
      this.xRangeMax = 10.0,
      this.numPoints = 500,
      required final List<double> xValues,
      required final List<double?> yValues,
      required this.title,
      this.color = '#6366f1',
      required this.generatedAt})
      : _xValues = xValues,
        _yValues = yValues,
        super._();

  factory _$GraphDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$GraphDataImplFromJson(json);

  @override
  final String id;
  @override
  final String expressionId;
  @override
  @JsonKey()
  final String variable;
  @override
  @JsonKey()
  final double xRangeMin;
  @override
  @JsonKey()
  final double xRangeMax;
  @override
  @JsonKey()
  final int numPoints;
  final List<double> _xValues;
  @override
  List<double> get xValues {
    if (_xValues is EqualUnmodifiableListView) return _xValues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_xValues);
  }

  final List<double?> _yValues;
  @override
  List<double?> get yValues {
    if (_yValues is EqualUnmodifiableListView) return _yValues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_yValues);
  }

  @override
  final String title;
  @override
  @JsonKey()
  final String color;
  @override
  final DateTime generatedAt;

  @override
  String toString() {
    return 'GraphData(id: $id, expressionId: $expressionId, variable: $variable, xRangeMin: $xRangeMin, xRangeMax: $xRangeMax, numPoints: $numPoints, xValues: $xValues, yValues: $yValues, title: $title, color: $color, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GraphDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.expressionId, expressionId) ||
                other.expressionId == expressionId) &&
            (identical(other.variable, variable) ||
                other.variable == variable) &&
            (identical(other.xRangeMin, xRangeMin) ||
                other.xRangeMin == xRangeMin) &&
            (identical(other.xRangeMax, xRangeMax) ||
                other.xRangeMax == xRangeMax) &&
            (identical(other.numPoints, numPoints) ||
                other.numPoints == numPoints) &&
            const DeepCollectionEquality().equals(other._xValues, _xValues) &&
            const DeepCollectionEquality().equals(other._yValues, _yValues) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      expressionId,
      variable,
      xRangeMin,
      xRangeMax,
      numPoints,
      const DeepCollectionEquality().hash(_xValues),
      const DeepCollectionEquality().hash(_yValues),
      title,
      color,
      generatedAt);

  /// Create a copy of GraphData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GraphDataImplCopyWith<_$GraphDataImpl> get copyWith =>
      __$$GraphDataImplCopyWithImpl<_$GraphDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GraphDataImplToJson(
      this,
    );
  }
}

abstract class _GraphData extends GraphData {
  const factory _GraphData(
      {required final String id,
      required final String expressionId,
      final String variable,
      final double xRangeMin,
      final double xRangeMax,
      final int numPoints,
      required final List<double> xValues,
      required final List<double?> yValues,
      required final String title,
      final String color,
      required final DateTime generatedAt}) = _$GraphDataImpl;
  const _GraphData._() : super._();

  factory _GraphData.fromJson(Map<String, dynamic> json) =
      _$GraphDataImpl.fromJson;

  @override
  String get id;
  @override
  String get expressionId;
  @override
  String get variable;
  @override
  double get xRangeMin;
  @override
  double get xRangeMax;
  @override
  int get numPoints;
  @override
  List<double> get xValues;
  @override
  List<double?> get yValues;
  @override
  String get title;
  @override
  String get color;
  @override
  DateTime get generatedAt;

  /// Create a copy of GraphData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GraphDataImplCopyWith<_$GraphDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
