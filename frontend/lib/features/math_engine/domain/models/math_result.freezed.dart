// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'math_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MathResult _$MathResultFromJson(Map<String, dynamic> json) {
  return _MathResult.fromJson(json);
}

/// @nodoc
mixin _$MathResult {
  String get id => throw _privateConstructorUsedError;
  String get expressionId => throw _privateConstructorUsedError;
  String get resultType =>
      throw _privateConstructorUsedError; // 'numeric', 'solution', 'simplified', 'error'
  String get value => throw _privateConstructorUsedError;
  String get latex => throw _privateConstructorUsedError;
  double? get numericValue => throw _privateConstructorUsedError;
  DateTime get computedAt => throw _privateConstructorUsedError;

  /// Serializes this MathResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MathResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MathResultCopyWith<MathResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MathResultCopyWith<$Res> {
  factory $MathResultCopyWith(
          MathResult value, $Res Function(MathResult) then) =
      _$MathResultCopyWithImpl<$Res, MathResult>;
  @useResult
  $Res call(
      {String id,
      String expressionId,
      String resultType,
      String value,
      String latex,
      double? numericValue,
      DateTime computedAt});
}

/// @nodoc
class _$MathResultCopyWithImpl<$Res, $Val extends MathResult>
    implements $MathResultCopyWith<$Res> {
  _$MathResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MathResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? expressionId = null,
    Object? resultType = null,
    Object? value = null,
    Object? latex = null,
    Object? numericValue = freezed,
    Object? computedAt = null,
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
      resultType: null == resultType
          ? _value.resultType
          : resultType // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      latex: null == latex
          ? _value.latex
          : latex // ignore: cast_nullable_to_non_nullable
              as String,
      numericValue: freezed == numericValue
          ? _value.numericValue
          : numericValue // ignore: cast_nullable_to_non_nullable
              as double?,
      computedAt: null == computedAt
          ? _value.computedAt
          : computedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MathResultImplCopyWith<$Res>
    implements $MathResultCopyWith<$Res> {
  factory _$$MathResultImplCopyWith(
          _$MathResultImpl value, $Res Function(_$MathResultImpl) then) =
      __$$MathResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String expressionId,
      String resultType,
      String value,
      String latex,
      double? numericValue,
      DateTime computedAt});
}

/// @nodoc
class __$$MathResultImplCopyWithImpl<$Res>
    extends _$MathResultCopyWithImpl<$Res, _$MathResultImpl>
    implements _$$MathResultImplCopyWith<$Res> {
  __$$MathResultImplCopyWithImpl(
      _$MathResultImpl _value, $Res Function(_$MathResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of MathResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? expressionId = null,
    Object? resultType = null,
    Object? value = null,
    Object? latex = null,
    Object? numericValue = freezed,
    Object? computedAt = null,
  }) {
    return _then(_$MathResultImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      expressionId: null == expressionId
          ? _value.expressionId
          : expressionId // ignore: cast_nullable_to_non_nullable
              as String,
      resultType: null == resultType
          ? _value.resultType
          : resultType // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      latex: null == latex
          ? _value.latex
          : latex // ignore: cast_nullable_to_non_nullable
              as String,
      numericValue: freezed == numericValue
          ? _value.numericValue
          : numericValue // ignore: cast_nullable_to_non_nullable
              as double?,
      computedAt: null == computedAt
          ? _value.computedAt
          : computedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MathResultImpl extends _MathResult {
  const _$MathResultImpl(
      {required this.id,
      required this.expressionId,
      required this.resultType,
      required this.value,
      required this.latex,
      this.numericValue,
      required this.computedAt})
      : super._();

  factory _$MathResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$MathResultImplFromJson(json);

  @override
  final String id;
  @override
  final String expressionId;
  @override
  final String resultType;
// 'numeric', 'solution', 'simplified', 'error'
  @override
  final String value;
  @override
  final String latex;
  @override
  final double? numericValue;
  @override
  final DateTime computedAt;

  @override
  String toString() {
    return 'MathResult(id: $id, expressionId: $expressionId, resultType: $resultType, value: $value, latex: $latex, numericValue: $numericValue, computedAt: $computedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MathResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.expressionId, expressionId) ||
                other.expressionId == expressionId) &&
            (identical(other.resultType, resultType) ||
                other.resultType == resultType) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.latex, latex) || other.latex == latex) &&
            (identical(other.numericValue, numericValue) ||
                other.numericValue == numericValue) &&
            (identical(other.computedAt, computedAt) ||
                other.computedAt == computedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, expressionId, resultType,
      value, latex, numericValue, computedAt);

  /// Create a copy of MathResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MathResultImplCopyWith<_$MathResultImpl> get copyWith =>
      __$$MathResultImplCopyWithImpl<_$MathResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MathResultImplToJson(
      this,
    );
  }
}

abstract class _MathResult extends MathResult {
  const factory _MathResult(
      {required final String id,
      required final String expressionId,
      required final String resultType,
      required final String value,
      required final String latex,
      final double? numericValue,
      required final DateTime computedAt}) = _$MathResultImpl;
  const _MathResult._() : super._();

  factory _MathResult.fromJson(Map<String, dynamic> json) =
      _$MathResultImpl.fromJson;

  @override
  String get id;
  @override
  String get expressionId;
  @override
  String get resultType; // 'numeric', 'solution', 'simplified', 'error'
  @override
  String get value;
  @override
  String get latex;
  @override
  double? get numericValue;
  @override
  DateTime get computedAt;

  /// Create a copy of MathResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MathResultImplCopyWith<_$MathResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
