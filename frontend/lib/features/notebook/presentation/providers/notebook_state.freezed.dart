// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notebook_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotebookState _$NotebookStateFromJson(Map<String, dynamic> json) {
  return _NotebookState.fromJson(json);
}

/// @nodoc
mixin _$NotebookState {
  /// List of all notebooks in the system.
  List<Notebook> get notebooks => throw _privateConstructorUsedError;

  /// Currently active/selected notebook, if any.
  Notebook? get activeNotebook => throw _privateConstructorUsedError;

  /// Loading state indicator.
  bool get isPending => throw _privateConstructorUsedError;

  /// Error message from the last operation, if any.
  String? get error => throw _privateConstructorUsedError;

  /// Serializes this NotebookState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotebookState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotebookStateCopyWith<NotebookState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotebookStateCopyWith<$Res> {
  factory $NotebookStateCopyWith(
          NotebookState value, $Res Function(NotebookState) then) =
      _$NotebookStateCopyWithImpl<$Res, NotebookState>;
  @useResult
  $Res call(
      {List<Notebook> notebooks,
      Notebook? activeNotebook,
      bool isPending,
      String? error});

  $NotebookCopyWith<$Res>? get activeNotebook;
}

/// @nodoc
class _$NotebookStateCopyWithImpl<$Res, $Val extends NotebookState>
    implements $NotebookStateCopyWith<$Res> {
  _$NotebookStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotebookState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notebooks = null,
    Object? activeNotebook = freezed,
    Object? isPending = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      notebooks: null == notebooks
          ? _value.notebooks
          : notebooks // ignore: cast_nullable_to_non_nullable
              as List<Notebook>,
      activeNotebook: freezed == activeNotebook
          ? _value.activeNotebook
          : activeNotebook // ignore: cast_nullable_to_non_nullable
              as Notebook?,
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

  /// Create a copy of NotebookState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NotebookCopyWith<$Res>? get activeNotebook {
    if (_value.activeNotebook == null) {
      return null;
    }

    return $NotebookCopyWith<$Res>(_value.activeNotebook!, (value) {
      return _then(_value.copyWith(activeNotebook: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NotebookStateImplCopyWith<$Res>
    implements $NotebookStateCopyWith<$Res> {
  factory _$$NotebookStateImplCopyWith(
          _$NotebookStateImpl value, $Res Function(_$NotebookStateImpl) then) =
      __$$NotebookStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Notebook> notebooks,
      Notebook? activeNotebook,
      bool isPending,
      String? error});

  @override
  $NotebookCopyWith<$Res>? get activeNotebook;
}

/// @nodoc
class __$$NotebookStateImplCopyWithImpl<$Res>
    extends _$NotebookStateCopyWithImpl<$Res, _$NotebookStateImpl>
    implements _$$NotebookStateImplCopyWith<$Res> {
  __$$NotebookStateImplCopyWithImpl(
      _$NotebookStateImpl _value, $Res Function(_$NotebookStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotebookState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notebooks = null,
    Object? activeNotebook = freezed,
    Object? isPending = null,
    Object? error = freezed,
  }) {
    return _then(_$NotebookStateImpl(
      notebooks: null == notebooks
          ? _value._notebooks
          : notebooks // ignore: cast_nullable_to_non_nullable
              as List<Notebook>,
      activeNotebook: freezed == activeNotebook
          ? _value.activeNotebook
          : activeNotebook // ignore: cast_nullable_to_non_nullable
              as Notebook?,
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
@JsonSerializable()
class _$NotebookStateImpl implements _NotebookState {
  const _$NotebookStateImpl(
      {final List<Notebook> notebooks = const <Notebook>[],
      this.activeNotebook,
      this.isPending = false,
      this.error})
      : _notebooks = notebooks;

  factory _$NotebookStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotebookStateImplFromJson(json);

  /// List of all notebooks in the system.
  final List<Notebook> _notebooks;

  /// List of all notebooks in the system.
  @override
  @JsonKey()
  List<Notebook> get notebooks {
    if (_notebooks is EqualUnmodifiableListView) return _notebooks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notebooks);
  }

  /// Currently active/selected notebook, if any.
  @override
  final Notebook? activeNotebook;

  /// Loading state indicator.
  @override
  @JsonKey()
  final bool isPending;

  /// Error message from the last operation, if any.
  @override
  final String? error;

  @override
  String toString() {
    return 'NotebookState(notebooks: $notebooks, activeNotebook: $activeNotebook, isPending: $isPending, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotebookStateImpl &&
            const DeepCollectionEquality()
                .equals(other._notebooks, _notebooks) &&
            (identical(other.activeNotebook, activeNotebook) ||
                other.activeNotebook == activeNotebook) &&
            (identical(other.isPending, isPending) ||
                other.isPending == isPending) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_notebooks),
      activeNotebook,
      isPending,
      error);

  /// Create a copy of NotebookState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotebookStateImplCopyWith<_$NotebookStateImpl> get copyWith =>
      __$$NotebookStateImplCopyWithImpl<_$NotebookStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotebookStateImplToJson(
      this,
    );
  }
}

abstract class _NotebookState implements NotebookState {
  const factory _NotebookState(
      {final List<Notebook> notebooks,
      final Notebook? activeNotebook,
      final bool isPending,
      final String? error}) = _$NotebookStateImpl;

  factory _NotebookState.fromJson(Map<String, dynamic> json) =
      _$NotebookStateImpl.fromJson;

  /// List of all notebooks in the system.
  @override
  List<Notebook> get notebooks;

  /// Currently active/selected notebook, if any.
  @override
  Notebook? get activeNotebook;

  /// Loading state indicator.
  @override
  bool get isPending;

  /// Error message from the last operation, if any.
  @override
  String? get error;

  /// Create a copy of NotebookState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotebookStateImplCopyWith<_$NotebookStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
