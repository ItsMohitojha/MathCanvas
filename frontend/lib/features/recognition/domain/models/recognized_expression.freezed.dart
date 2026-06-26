// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recognized_expression.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecognizedExpression _$RecognizedExpressionFromJson(Map<String, dynamic> json) {
  return _RecognizedExpression.fromJson(json);
}

/// @nodoc
mixin _$RecognizedExpression {
  String get id => throw _privateConstructorUsedError;
  String get notebookId => throw _privateConstructorUsedError;
  String get rawLatex => throw _privateConstructorUsedError;
  String? get parsedExpression => throw _privateConstructorUsedError;
  String get expressionType => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  double get bboxMinX => throw _privateConstructorUsedError;
  double get bboxMinY => throw _privateConstructorUsedError;
  double get bboxMaxX => throw _privateConstructorUsedError;
  double get bboxMaxY => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<String> get strokeIds => throw _privateConstructorUsedError;

  /// Serializes this RecognizedExpression to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecognizedExpression
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecognizedExpressionCopyWith<RecognizedExpression> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecognizedExpressionCopyWith<$Res> {
  factory $RecognizedExpressionCopyWith(RecognizedExpression value,
          $Res Function(RecognizedExpression) then) =
      _$RecognizedExpressionCopyWithImpl<$Res, RecognizedExpression>;
  @useResult
  $Res call(
      {String id,
      String notebookId,
      String rawLatex,
      String? parsedExpression,
      String expressionType,
      double confidence,
      double bboxMinX,
      double bboxMinY,
      double bboxMaxX,
      double bboxMaxY,
      DateTime createdAt,
      DateTime updatedAt,
      List<String> strokeIds});
}

/// @nodoc
class _$RecognizedExpressionCopyWithImpl<$Res,
        $Val extends RecognizedExpression>
    implements $RecognizedExpressionCopyWith<$Res> {
  _$RecognizedExpressionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecognizedExpression
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? notebookId = null,
    Object? rawLatex = null,
    Object? parsedExpression = freezed,
    Object? expressionType = null,
    Object? confidence = null,
    Object? bboxMinX = null,
    Object? bboxMinY = null,
    Object? bboxMaxX = null,
    Object? bboxMaxY = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? strokeIds = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      notebookId: null == notebookId
          ? _value.notebookId
          : notebookId // ignore: cast_nullable_to_non_nullable
              as String,
      rawLatex: null == rawLatex
          ? _value.rawLatex
          : rawLatex // ignore: cast_nullable_to_non_nullable
              as String,
      parsedExpression: freezed == parsedExpression
          ? _value.parsedExpression
          : parsedExpression // ignore: cast_nullable_to_non_nullable
              as String?,
      expressionType: null == expressionType
          ? _value.expressionType
          : expressionType // ignore: cast_nullable_to_non_nullable
              as String,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      bboxMinX: null == bboxMinX
          ? _value.bboxMinX
          : bboxMinX // ignore: cast_nullable_to_non_nullable
              as double,
      bboxMinY: null == bboxMinY
          ? _value.bboxMinY
          : bboxMinY // ignore: cast_nullable_to_non_nullable
              as double,
      bboxMaxX: null == bboxMaxX
          ? _value.bboxMaxX
          : bboxMaxX // ignore: cast_nullable_to_non_nullable
              as double,
      bboxMaxY: null == bboxMaxY
          ? _value.bboxMaxY
          : bboxMaxY // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      strokeIds: null == strokeIds
          ? _value.strokeIds
          : strokeIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecognizedExpressionImplCopyWith<$Res>
    implements $RecognizedExpressionCopyWith<$Res> {
  factory _$$RecognizedExpressionImplCopyWith(_$RecognizedExpressionImpl value,
          $Res Function(_$RecognizedExpressionImpl) then) =
      __$$RecognizedExpressionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String notebookId,
      String rawLatex,
      String? parsedExpression,
      String expressionType,
      double confidence,
      double bboxMinX,
      double bboxMinY,
      double bboxMaxX,
      double bboxMaxY,
      DateTime createdAt,
      DateTime updatedAt,
      List<String> strokeIds});
}

/// @nodoc
class __$$RecognizedExpressionImplCopyWithImpl<$Res>
    extends _$RecognizedExpressionCopyWithImpl<$Res, _$RecognizedExpressionImpl>
    implements _$$RecognizedExpressionImplCopyWith<$Res> {
  __$$RecognizedExpressionImplCopyWithImpl(_$RecognizedExpressionImpl _value,
      $Res Function(_$RecognizedExpressionImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecognizedExpression
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? notebookId = null,
    Object? rawLatex = null,
    Object? parsedExpression = freezed,
    Object? expressionType = null,
    Object? confidence = null,
    Object? bboxMinX = null,
    Object? bboxMinY = null,
    Object? bboxMaxX = null,
    Object? bboxMaxY = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? strokeIds = null,
  }) {
    return _then(_$RecognizedExpressionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      notebookId: null == notebookId
          ? _value.notebookId
          : notebookId // ignore: cast_nullable_to_non_nullable
              as String,
      rawLatex: null == rawLatex
          ? _value.rawLatex
          : rawLatex // ignore: cast_nullable_to_non_nullable
              as String,
      parsedExpression: freezed == parsedExpression
          ? _value.parsedExpression
          : parsedExpression // ignore: cast_nullable_to_non_nullable
              as String?,
      expressionType: null == expressionType
          ? _value.expressionType
          : expressionType // ignore: cast_nullable_to_non_nullable
              as String,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      bboxMinX: null == bboxMinX
          ? _value.bboxMinX
          : bboxMinX // ignore: cast_nullable_to_non_nullable
              as double,
      bboxMinY: null == bboxMinY
          ? _value.bboxMinY
          : bboxMinY // ignore: cast_nullable_to_non_nullable
              as double,
      bboxMaxX: null == bboxMaxX
          ? _value.bboxMaxX
          : bboxMaxX // ignore: cast_nullable_to_non_nullable
              as double,
      bboxMaxY: null == bboxMaxY
          ? _value.bboxMaxY
          : bboxMaxY // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      strokeIds: null == strokeIds
          ? _value._strokeIds
          : strokeIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecognizedExpressionImpl extends _RecognizedExpression {
  const _$RecognizedExpressionImpl(
      {required this.id,
      required this.notebookId,
      required this.rawLatex,
      this.parsedExpression,
      this.expressionType = 'unknown',
      required this.confidence,
      required this.bboxMinX,
      required this.bboxMinY,
      required this.bboxMaxX,
      required this.bboxMaxY,
      required this.createdAt,
      required this.updatedAt,
      required final List<String> strokeIds})
      : _strokeIds = strokeIds,
        super._();

  factory _$RecognizedExpressionImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecognizedExpressionImplFromJson(json);

  @override
  final String id;
  @override
  final String notebookId;
  @override
  final String rawLatex;
  @override
  final String? parsedExpression;
  @override
  @JsonKey()
  final String expressionType;
  @override
  final double confidence;
  @override
  final double bboxMinX;
  @override
  final double bboxMinY;
  @override
  final double bboxMaxX;
  @override
  final double bboxMaxY;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<String> _strokeIds;
  @override
  List<String> get strokeIds {
    if (_strokeIds is EqualUnmodifiableListView) return _strokeIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_strokeIds);
  }

  @override
  String toString() {
    return 'RecognizedExpression(id: $id, notebookId: $notebookId, rawLatex: $rawLatex, parsedExpression: $parsedExpression, expressionType: $expressionType, confidence: $confidence, bboxMinX: $bboxMinX, bboxMinY: $bboxMinY, bboxMaxX: $bboxMaxX, bboxMaxY: $bboxMaxY, createdAt: $createdAt, updatedAt: $updatedAt, strokeIds: $strokeIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecognizedExpressionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.notebookId, notebookId) ||
                other.notebookId == notebookId) &&
            (identical(other.rawLatex, rawLatex) ||
                other.rawLatex == rawLatex) &&
            (identical(other.parsedExpression, parsedExpression) ||
                other.parsedExpression == parsedExpression) &&
            (identical(other.expressionType, expressionType) ||
                other.expressionType == expressionType) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.bboxMinX, bboxMinX) ||
                other.bboxMinX == bboxMinX) &&
            (identical(other.bboxMinY, bboxMinY) ||
                other.bboxMinY == bboxMinY) &&
            (identical(other.bboxMaxX, bboxMaxX) ||
                other.bboxMaxX == bboxMaxX) &&
            (identical(other.bboxMaxY, bboxMaxY) ||
                other.bboxMaxY == bboxMaxY) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._strokeIds, _strokeIds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      notebookId,
      rawLatex,
      parsedExpression,
      expressionType,
      confidence,
      bboxMinX,
      bboxMinY,
      bboxMaxX,
      bboxMaxY,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_strokeIds));

  /// Create a copy of RecognizedExpression
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecognizedExpressionImplCopyWith<_$RecognizedExpressionImpl>
      get copyWith =>
          __$$RecognizedExpressionImplCopyWithImpl<_$RecognizedExpressionImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecognizedExpressionImplToJson(
      this,
    );
  }
}

abstract class _RecognizedExpression extends RecognizedExpression {
  const factory _RecognizedExpression(
      {required final String id,
      required final String notebookId,
      required final String rawLatex,
      final String? parsedExpression,
      final String expressionType,
      required final double confidence,
      required final double bboxMinX,
      required final double bboxMinY,
      required final double bboxMaxX,
      required final double bboxMaxY,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      required final List<String> strokeIds}) = _$RecognizedExpressionImpl;
  const _RecognizedExpression._() : super._();

  factory _RecognizedExpression.fromJson(Map<String, dynamic> json) =
      _$RecognizedExpressionImpl.fromJson;

  @override
  String get id;
  @override
  String get notebookId;
  @override
  String get rawLatex;
  @override
  String? get parsedExpression;
  @override
  String get expressionType;
  @override
  double get confidence;
  @override
  double get bboxMinX;
  @override
  double get bboxMinY;
  @override
  double get bboxMaxX;
  @override
  double get bboxMaxY;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  List<String> get strokeIds;

  /// Create a copy of RecognizedExpression
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecognizedExpressionImplCopyWith<_$RecognizedExpressionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
