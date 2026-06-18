// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'canvas_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CanvasState {
  Offset get viewportOffset => throw _privateConstructorUsedError;
  double get zoomLevel => throw _privateConstructorUsedError;
  CanvasMode get mode => throw _privateConstructorUsedError;
  bool get showHint => throw _privateConstructorUsedError;
  List<Stroke> get strokes => throw _privateConstructorUsedError;
  Stroke? get currentStroke => throw _privateConstructorUsedError;
  String? get currentNotebookId => throw _privateConstructorUsedError;

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CanvasStateCopyWith<CanvasState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CanvasStateCopyWith<$Res> {
  factory $CanvasStateCopyWith(
          CanvasState value, $Res Function(CanvasState) then) =
      _$CanvasStateCopyWithImpl<$Res, CanvasState>;
  @useResult
  $Res call(
      {Offset viewportOffset,
      double zoomLevel,
      CanvasMode mode,
      bool showHint,
      List<Stroke> strokes,
      Stroke? currentStroke,
      String? currentNotebookId});

  $StrokeCopyWith<$Res>? get currentStroke;
}

/// @nodoc
class _$CanvasStateCopyWithImpl<$Res, $Val extends CanvasState>
    implements $CanvasStateCopyWith<$Res> {
  _$CanvasStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? viewportOffset = null,
    Object? zoomLevel = null,
    Object? mode = null,
    Object? showHint = null,
    Object? strokes = null,
    Object? currentStroke = freezed,
    Object? currentNotebookId = freezed,
  }) {
    return _then(_value.copyWith(
      viewportOffset: null == viewportOffset
          ? _value.viewportOffset
          : viewportOffset // ignore: cast_nullable_to_non_nullable
              as Offset,
      zoomLevel: null == zoomLevel
          ? _value.zoomLevel
          : zoomLevel // ignore: cast_nullable_to_non_nullable
              as double,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as CanvasMode,
      showHint: null == showHint
          ? _value.showHint
          : showHint // ignore: cast_nullable_to_non_nullable
              as bool,
      strokes: null == strokes
          ? _value.strokes
          : strokes // ignore: cast_nullable_to_non_nullable
              as List<Stroke>,
      currentStroke: freezed == currentStroke
          ? _value.currentStroke
          : currentStroke // ignore: cast_nullable_to_non_nullable
              as Stroke?,
      currentNotebookId: freezed == currentNotebookId
          ? _value.currentNotebookId
          : currentNotebookId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StrokeCopyWith<$Res>? get currentStroke {
    if (_value.currentStroke == null) {
      return null;
    }

    return $StrokeCopyWith<$Res>(_value.currentStroke!, (value) {
      return _then(_value.copyWith(currentStroke: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CanvasStateImplCopyWith<$Res>
    implements $CanvasStateCopyWith<$Res> {
  factory _$$CanvasStateImplCopyWith(
          _$CanvasStateImpl value, $Res Function(_$CanvasStateImpl) then) =
      __$$CanvasStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Offset viewportOffset,
      double zoomLevel,
      CanvasMode mode,
      bool showHint,
      List<Stroke> strokes,
      Stroke? currentStroke,
      String? currentNotebookId});

  @override
  $StrokeCopyWith<$Res>? get currentStroke;
}

/// @nodoc
class __$$CanvasStateImplCopyWithImpl<$Res>
    extends _$CanvasStateCopyWithImpl<$Res, _$CanvasStateImpl>
    implements _$$CanvasStateImplCopyWith<$Res> {
  __$$CanvasStateImplCopyWithImpl(
      _$CanvasStateImpl _value, $Res Function(_$CanvasStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? viewportOffset = null,
    Object? zoomLevel = null,
    Object? mode = null,
    Object? showHint = null,
    Object? strokes = null,
    Object? currentStroke = freezed,
    Object? currentNotebookId = freezed,
  }) {
    return _then(_$CanvasStateImpl(
      viewportOffset: null == viewportOffset
          ? _value.viewportOffset
          : viewportOffset // ignore: cast_nullable_to_non_nullable
              as Offset,
      zoomLevel: null == zoomLevel
          ? _value.zoomLevel
          : zoomLevel // ignore: cast_nullable_to_non_nullable
              as double,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as CanvasMode,
      showHint: null == showHint
          ? _value.showHint
          : showHint // ignore: cast_nullable_to_non_nullable
              as bool,
      strokes: null == strokes
          ? _value._strokes
          : strokes // ignore: cast_nullable_to_non_nullable
              as List<Stroke>,
      currentStroke: freezed == currentStroke
          ? _value.currentStroke
          : currentStroke // ignore: cast_nullable_to_non_nullable
              as Stroke?,
      currentNotebookId: freezed == currentNotebookId
          ? _value.currentNotebookId
          : currentNotebookId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CanvasStateImpl implements _CanvasState {
  const _$CanvasStateImpl(
      {this.viewportOffset = Offset.zero,
      this.zoomLevel = 1.0,
      this.mode = CanvasMode.draw,
      this.showHint = true,
      final List<Stroke> strokes = const <Stroke>[],
      this.currentStroke,
      this.currentNotebookId})
      : _strokes = strokes;

  @override
  @JsonKey()
  final Offset viewportOffset;
  @override
  @JsonKey()
  final double zoomLevel;
  @override
  @JsonKey()
  final CanvasMode mode;
  @override
  @JsonKey()
  final bool showHint;
  final List<Stroke> _strokes;
  @override
  @JsonKey()
  List<Stroke> get strokes {
    if (_strokes is EqualUnmodifiableListView) return _strokes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_strokes);
  }

  @override
  final Stroke? currentStroke;
  @override
  final String? currentNotebookId;

  @override
  String toString() {
    return 'CanvasState(viewportOffset: $viewportOffset, zoomLevel: $zoomLevel, mode: $mode, showHint: $showHint, strokes: $strokes, currentStroke: $currentStroke, currentNotebookId: $currentNotebookId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CanvasStateImpl &&
            (identical(other.viewportOffset, viewportOffset) ||
                other.viewportOffset == viewportOffset) &&
            (identical(other.zoomLevel, zoomLevel) ||
                other.zoomLevel == zoomLevel) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.showHint, showHint) ||
                other.showHint == showHint) &&
            const DeepCollectionEquality().equals(other._strokes, _strokes) &&
            (identical(other.currentStroke, currentStroke) ||
                other.currentStroke == currentStroke) &&
            (identical(other.currentNotebookId, currentNotebookId) ||
                other.currentNotebookId == currentNotebookId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      viewportOffset,
      zoomLevel,
      mode,
      showHint,
      const DeepCollectionEquality().hash(_strokes),
      currentStroke,
      currentNotebookId);

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CanvasStateImplCopyWith<_$CanvasStateImpl> get copyWith =>
      __$$CanvasStateImplCopyWithImpl<_$CanvasStateImpl>(this, _$identity);
}

abstract class _CanvasState implements CanvasState {
  const factory _CanvasState(
      {final Offset viewportOffset,
      final double zoomLevel,
      final CanvasMode mode,
      final bool showHint,
      final List<Stroke> strokes,
      final Stroke? currentStroke,
      final String? currentNotebookId}) = _$CanvasStateImpl;

  @override
  Offset get viewportOffset;
  @override
  double get zoomLevel;
  @override
  CanvasMode get mode;
  @override
  bool get showHint;
  @override
  List<Stroke> get strokes;
  @override
  Stroke? get currentStroke;
  @override
  String? get currentNotebookId;

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CanvasStateImplCopyWith<_$CanvasStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
