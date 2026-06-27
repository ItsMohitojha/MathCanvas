// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'math_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MathState _$MathStateFromJson(Map<String, dynamic> json) {
  return _MathState.fromJson(json);
}

/// @nodoc
mixin _$MathState {
  Map<String, MathResult> get results => throw _privateConstructorUsedError;
  Map<String, String> get symbolTable => throw _privateConstructorUsedError;
  Map<String, Set<String>> get dependencies =>
      throw _privateConstructorUsedError;
  Map<String, String> get definedVariables =>
      throw _privateConstructorUsedError;
  bool get isPending => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Serializes this MathState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MathState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MathStateCopyWith<MathState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MathStateCopyWith<$Res> {
  factory $MathStateCopyWith(MathState value, $Res Function(MathState) then) =
      _$MathStateCopyWithImpl<$Res, MathState>;
  @useResult
  $Res call(
      {Map<String, MathResult> results,
      Map<String, String> symbolTable,
      Map<String, Set<String>> dependencies,
      Map<String, String> definedVariables,
      bool isPending,
      String? error});
}

/// @nodoc
class _$MathStateCopyWithImpl<$Res, $Val extends MathState>
    implements $MathStateCopyWith<$Res> {
  _$MathStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MathState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? results = null,
    Object? symbolTable = null,
    Object? dependencies = null,
    Object? definedVariables = null,
    Object? isPending = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      results: null == results
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as Map<String, MathResult>,
      symbolTable: null == symbolTable
          ? _value.symbolTable
          : symbolTable // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      dependencies: null == dependencies
          ? _value.dependencies
          : dependencies // ignore: cast_nullable_to_non_nullable
              as Map<String, Set<String>>,
      definedVariables: null == definedVariables
          ? _value.definedVariables
          : definedVariables // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
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
abstract class _$$MathStateImplCopyWith<$Res>
    implements $MathStateCopyWith<$Res> {
  factory _$$MathStateImplCopyWith(
          _$MathStateImpl value, $Res Function(_$MathStateImpl) then) =
      __$$MathStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, MathResult> results,
      Map<String, String> symbolTable,
      Map<String, Set<String>> dependencies,
      Map<String, String> definedVariables,
      bool isPending,
      String? error});
}

/// @nodoc
class __$$MathStateImplCopyWithImpl<$Res>
    extends _$MathStateCopyWithImpl<$Res, _$MathStateImpl>
    implements _$$MathStateImplCopyWith<$Res> {
  __$$MathStateImplCopyWithImpl(
      _$MathStateImpl _value, $Res Function(_$MathStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MathState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? results = null,
    Object? symbolTable = null,
    Object? dependencies = null,
    Object? definedVariables = null,
    Object? isPending = null,
    Object? error = freezed,
  }) {
    return _then(_$MathStateImpl(
      results: null == results
          ? _value._results
          : results // ignore: cast_nullable_to_non_nullable
              as Map<String, MathResult>,
      symbolTable: null == symbolTable
          ? _value._symbolTable
          : symbolTable // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      dependencies: null == dependencies
          ? _value._dependencies
          : dependencies // ignore: cast_nullable_to_non_nullable
              as Map<String, Set<String>>,
      definedVariables: null == definedVariables
          ? _value._definedVariables
          : definedVariables // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
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
class _$MathStateImpl implements _MathState {
  const _$MathStateImpl(
      {final Map<String, MathResult> results = const <String, MathResult>{},
      final Map<String, String> symbolTable = const <String, String>{},
      final Map<String, Set<String>> dependencies =
          const <String, Set<String>>{},
      final Map<String, String> definedVariables = const <String, String>{},
      this.isPending = false,
      this.error})
      : _results = results,
        _symbolTable = symbolTable,
        _dependencies = dependencies,
        _definedVariables = definedVariables;

  factory _$MathStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$MathStateImplFromJson(json);

  final Map<String, MathResult> _results;
  @override
  @JsonKey()
  Map<String, MathResult> get results {
    if (_results is EqualUnmodifiableMapView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_results);
  }

  final Map<String, String> _symbolTable;
  @override
  @JsonKey()
  Map<String, String> get symbolTable {
    if (_symbolTable is EqualUnmodifiableMapView) return _symbolTable;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_symbolTable);
  }

  final Map<String, Set<String>> _dependencies;
  @override
  @JsonKey()
  Map<String, Set<String>> get dependencies {
    if (_dependencies is EqualUnmodifiableMapView) return _dependencies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_dependencies);
  }

  final Map<String, String> _definedVariables;
  @override
  @JsonKey()
  Map<String, String> get definedVariables {
    if (_definedVariables is EqualUnmodifiableMapView) return _definedVariables;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_definedVariables);
  }

  @override
  @JsonKey()
  final bool isPending;
  @override
  final String? error;

  @override
  String toString() {
    return 'MathState(results: $results, symbolTable: $symbolTable, dependencies: $dependencies, definedVariables: $definedVariables, isPending: $isPending, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MathStateImpl &&
            const DeepCollectionEquality().equals(other._results, _results) &&
            const DeepCollectionEquality()
                .equals(other._symbolTable, _symbolTable) &&
            const DeepCollectionEquality()
                .equals(other._dependencies, _dependencies) &&
            const DeepCollectionEquality()
                .equals(other._definedVariables, _definedVariables) &&
            (identical(other.isPending, isPending) ||
                other.isPending == isPending) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_results),
      const DeepCollectionEquality().hash(_symbolTable),
      const DeepCollectionEquality().hash(_dependencies),
      const DeepCollectionEquality().hash(_definedVariables),
      isPending,
      error);

  /// Create a copy of MathState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MathStateImplCopyWith<_$MathStateImpl> get copyWith =>
      __$$MathStateImplCopyWithImpl<_$MathStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MathStateImplToJson(
      this,
    );
  }
}

abstract class _MathState implements MathState {
  const factory _MathState(
      {final Map<String, MathResult> results,
      final Map<String, String> symbolTable,
      final Map<String, Set<String>> dependencies,
      final Map<String, String> definedVariables,
      final bool isPending,
      final String? error}) = _$MathStateImpl;

  factory _MathState.fromJson(Map<String, dynamic> json) =
      _$MathStateImpl.fromJson;

  @override
  Map<String, MathResult> get results;
  @override
  Map<String, String> get symbolTable;
  @override
  Map<String, Set<String>> get dependencies;
  @override
  Map<String, String> get definedVariables;
  @override
  bool get isPending;
  @override
  String? get error;

  /// Create a copy of MathState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MathStateImplCopyWith<_$MathStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
