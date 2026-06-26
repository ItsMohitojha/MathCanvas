// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recognition_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RecognitionResult {
  String get latex => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  Rect get boundingBox => throw _privateConstructorUsedError;
  List<String> get strokeIds => throw _privateConstructorUsedError;

  /// Create a copy of RecognitionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecognitionResultCopyWith<RecognitionResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecognitionResultCopyWith<$Res> {
  factory $RecognitionResultCopyWith(
          RecognitionResult value, $Res Function(RecognitionResult) then) =
      _$RecognitionResultCopyWithImpl<$Res, RecognitionResult>;
  @useResult
  $Res call(
      {String latex,
      double confidence,
      Rect boundingBox,
      List<String> strokeIds});
}

/// @nodoc
class _$RecognitionResultCopyWithImpl<$Res, $Val extends RecognitionResult>
    implements $RecognitionResultCopyWith<$Res> {
  _$RecognitionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecognitionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latex = null,
    Object? confidence = null,
    Object? boundingBox = null,
    Object? strokeIds = null,
  }) {
    return _then(_value.copyWith(
      latex: null == latex
          ? _value.latex
          : latex // ignore: cast_nullable_to_non_nullable
              as String,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      boundingBox: null == boundingBox
          ? _value.boundingBox
          : boundingBox // ignore: cast_nullable_to_non_nullable
              as Rect,
      strokeIds: null == strokeIds
          ? _value.strokeIds
          : strokeIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecognitionResultImplCopyWith<$Res>
    implements $RecognitionResultCopyWith<$Res> {
  factory _$$RecognitionResultImplCopyWith(_$RecognitionResultImpl value,
          $Res Function(_$RecognitionResultImpl) then) =
      __$$RecognitionResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String latex,
      double confidence,
      Rect boundingBox,
      List<String> strokeIds});
}

/// @nodoc
class __$$RecognitionResultImplCopyWithImpl<$Res>
    extends _$RecognitionResultCopyWithImpl<$Res, _$RecognitionResultImpl>
    implements _$$RecognitionResultImplCopyWith<$Res> {
  __$$RecognitionResultImplCopyWithImpl(_$RecognitionResultImpl _value,
      $Res Function(_$RecognitionResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecognitionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latex = null,
    Object? confidence = null,
    Object? boundingBox = null,
    Object? strokeIds = null,
  }) {
    return _then(_$RecognitionResultImpl(
      latex: null == latex
          ? _value.latex
          : latex // ignore: cast_nullable_to_non_nullable
              as String,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      boundingBox: null == boundingBox
          ? _value.boundingBox
          : boundingBox // ignore: cast_nullable_to_non_nullable
              as Rect,
      strokeIds: null == strokeIds
          ? _value._strokeIds
          : strokeIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$RecognitionResultImpl implements _RecognitionResult {
  const _$RecognitionResultImpl(
      {required this.latex,
      required this.confidence,
      required this.boundingBox,
      required final List<String> strokeIds})
      : _strokeIds = strokeIds;

  @override
  final String latex;
  @override
  final double confidence;
  @override
  final Rect boundingBox;
  final List<String> _strokeIds;
  @override
  List<String> get strokeIds {
    if (_strokeIds is EqualUnmodifiableListView) return _strokeIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_strokeIds);
  }

  @override
  String toString() {
    return 'RecognitionResult(latex: $latex, confidence: $confidence, boundingBox: $boundingBox, strokeIds: $strokeIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecognitionResultImpl &&
            (identical(other.latex, latex) || other.latex == latex) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.boundingBox, boundingBox) ||
                other.boundingBox == boundingBox) &&
            const DeepCollectionEquality()
                .equals(other._strokeIds, _strokeIds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, latex, confidence, boundingBox,
      const DeepCollectionEquality().hash(_strokeIds));

  /// Create a copy of RecognitionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecognitionResultImplCopyWith<_$RecognitionResultImpl> get copyWith =>
      __$$RecognitionResultImplCopyWithImpl<_$RecognitionResultImpl>(
          this, _$identity);
}

abstract class _RecognitionResult implements RecognitionResult {
  const factory _RecognitionResult(
      {required final String latex,
      required final double confidence,
      required final Rect boundingBox,
      required final List<String> strokeIds}) = _$RecognitionResultImpl;

  @override
  String get latex;
  @override
  double get confidence;
  @override
  Rect get boundingBox;
  @override
  List<String> get strokeIds;

  /// Create a copy of RecognitionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecognitionResultImplCopyWith<_$RecognitionResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
