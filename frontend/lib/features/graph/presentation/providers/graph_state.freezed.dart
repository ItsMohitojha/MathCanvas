// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'graph_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GraphState _$GraphStateFromJson(Map<String, dynamic> json) {
  return _GraphState.fromJson(json);
}

/// @nodoc
mixin _$GraphState {
  /// Active graphs keyed by expression ID.
  Map<String, GraphData> get graphs => throw _privateConstructorUsedError;

  /// Whether a graph generation is currently pending.
  bool get isPending => throw _privateConstructorUsedError;

  /// Error message if the last operation failed.
  String? get error => throw _privateConstructorUsedError;

  /// Serializes this GraphState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GraphState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GraphStateCopyWith<GraphState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GraphStateCopyWith<$Res> {
  factory $GraphStateCopyWith(
          GraphState value, $Res Function(GraphState) then) =
      _$GraphStateCopyWithImpl<$Res, GraphState>;
  @useResult
  $Res call({Map<String, GraphData> graphs, bool isPending, String? error});
}

/// @nodoc
class _$GraphStateCopyWithImpl<$Res, $Val extends GraphState>
    implements $GraphStateCopyWith<$Res> {
  _$GraphStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GraphState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? graphs = null,
    Object? isPending = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      graphs: null == graphs
          ? _value.graphs
          : graphs // ignore: cast_nullable_to_non_nullable
              as Map<String, GraphData>,
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
abstract class _$$GraphStateImplCopyWith<$Res>
    implements $GraphStateCopyWith<$Res> {
  factory _$$GraphStateImplCopyWith(
          _$GraphStateImpl value, $Res Function(_$GraphStateImpl) then) =
      __$$GraphStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, GraphData> graphs, bool isPending, String? error});
}

/// @nodoc
class __$$GraphStateImplCopyWithImpl<$Res>
    extends _$GraphStateCopyWithImpl<$Res, _$GraphStateImpl>
    implements _$$GraphStateImplCopyWith<$Res> {
  __$$GraphStateImplCopyWithImpl(
      _$GraphStateImpl _value, $Res Function(_$GraphStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of GraphState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? graphs = null,
    Object? isPending = null,
    Object? error = freezed,
  }) {
    return _then(_$GraphStateImpl(
      graphs: null == graphs
          ? _value._graphs
          : graphs // ignore: cast_nullable_to_non_nullable
              as Map<String, GraphData>,
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
class _$GraphStateImpl implements _GraphState {
  const _$GraphStateImpl(
      {final Map<String, GraphData> graphs = const <String, GraphData>{},
      this.isPending = false,
      this.error})
      : _graphs = graphs;

  factory _$GraphStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$GraphStateImplFromJson(json);

  /// Active graphs keyed by expression ID.
  final Map<String, GraphData> _graphs;

  /// Active graphs keyed by expression ID.
  @override
  @JsonKey()
  Map<String, GraphData> get graphs {
    if (_graphs is EqualUnmodifiableMapView) return _graphs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_graphs);
  }

  /// Whether a graph generation is currently pending.
  @override
  @JsonKey()
  final bool isPending;

  /// Error message if the last operation failed.
  @override
  final String? error;

  @override
  String toString() {
    return 'GraphState(graphs: $graphs, isPending: $isPending, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GraphStateImpl &&
            const DeepCollectionEquality().equals(other._graphs, _graphs) &&
            (identical(other.isPending, isPending) ||
                other.isPending == isPending) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_graphs), isPending, error);

  /// Create a copy of GraphState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GraphStateImplCopyWith<_$GraphStateImpl> get copyWith =>
      __$$GraphStateImplCopyWithImpl<_$GraphStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GraphStateImplToJson(
      this,
    );
  }
}

abstract class _GraphState implements GraphState {
  const factory _GraphState(
      {final Map<String, GraphData> graphs,
      final bool isPending,
      final String? error}) = _$GraphStateImpl;

  factory _GraphState.fromJson(Map<String, dynamic> json) =
      _$GraphStateImpl.fromJson;

  /// Active graphs keyed by expression ID.
  @override
  Map<String, GraphData> get graphs;

  /// Whether a graph generation is currently pending.
  @override
  bool get isPending;

  /// Error message if the last operation failed.
  @override
  String? get error;

  /// Create a copy of GraphState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GraphStateImplCopyWith<_$GraphStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
