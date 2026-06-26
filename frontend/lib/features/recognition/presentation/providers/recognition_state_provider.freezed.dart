// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recognition_state_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RecognitionState {
  List<RecognizedExpression> get expressions =>
      throw _privateConstructorUsedError;
  bool get isPending => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of RecognitionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecognitionStateCopyWith<RecognitionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecognitionStateCopyWith<$Res> {
  factory $RecognitionStateCopyWith(
          RecognitionState value, $Res Function(RecognitionState) then) =
      _$RecognitionStateCopyWithImpl<$Res, RecognitionState>;
  @useResult
  $Res call(
      {List<RecognizedExpression> expressions, bool isPending, String? error});
}

/// @nodoc
class _$RecognitionStateCopyWithImpl<$Res, $Val extends RecognitionState>
    implements $RecognitionStateCopyWith<$Res> {
  _$RecognitionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecognitionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expressions = null,
    Object? isPending = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      expressions: null == expressions
          ? _value.expressions
          : expressions // ignore: cast_nullable_to_non_nullable
              as List<RecognizedExpression>,
      isPending: null == isPending
          ? _value.isPending
          : isPending // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecognitionStateImplCopyWith<$Res>
    implements $RecognitionStateCopyWith<$Res> {
  factory _$$RecognitionStateImplCopyWith(_$RecognitionStateImpl value,
          $Res Function(_$RecognitionStateImpl) then) =
      __$$RecognitionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<RecognizedExpression> expressions, bool isPending, String? error});
}

/// @nodoc
class __$$RecognitionStateImplCopyWithImpl<$Res>
    extends _$RecognitionStateCopyWithImpl<$Res, _$RecognitionStateImpl>
    implements _$$RecognitionStateImplCopyWith<$Res> {
  __$$RecognitionStateImplCopyWithImpl(_$RecognitionStateImpl _value,
      $Res Function(_$RecognitionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecognitionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expressions = null,
    Object? isPending = null,
    Object? error = freezed,
  }) {
    return _then(_$RecognitionStateImpl(
      expressions: null == expressions
          ? _value._expressions
          : expressions // ignore: cast_nullable_to_non_nullable
              as List<RecognizedExpression>,
      isPending: null == isPending
          ? _value.isPending
          : isPending // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$RecognitionStateImpl implements _RecognitionState {
  const _$RecognitionStateImpl(
      {final List<RecognizedExpression> expressions =
          const <RecognizedExpression>[],
      this.isPending = false,
      this.error})
      : _expressions = expressions;

  final List<RecognizedExpression> _expressions;
  @override
  @JsonKey()
  List<RecognizedExpression> get expressions {
    if (_expressions is EqualUnmodifiableListView) return _expressions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expressions);
  }

  @override
  @JsonKey()
  final bool isPending;
  @override
  final String? error;

  @override
  String toString() {
    return 'RecognitionState(expressions: $expressions, isPending: $isPending, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecognitionStateImpl &&
            const DeepCollectionEquality()
                .equals(other._expressions, _expressions) &&
            (identical(other.isPending, isPending) ||
                other.isPending == isPending) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_expressions), isPending, error);

  /// Create a copy of RecognitionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecognitionStateImplCopyWith<_$RecognitionStateImpl> get copyWith =>
      __$$RecognitionStateImplCopyWithImpl<_$RecognitionStateImpl>(
          this, _$identity);
}

abstract class _RecognitionState implements RecognitionState {
  const factory _RecognitionState(
      {final List<RecognizedExpression> expressions,
      final bool isPending,
      final String? error}) = _$RecognitionStateImpl;

  @override
  List<RecognizedExpression> get expressions;
  @override
  bool get isPending;
  @override
  String? get error;

  /// Create a copy of RecognitionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecognitionStateImplCopyWith<_$RecognitionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
