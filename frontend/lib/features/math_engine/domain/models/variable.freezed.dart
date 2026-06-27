// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'variable.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Variable _$VariableFromJson(Map<String, dynamic> json) {
  return _Variable.fromJson(json);
}

/// @nodoc
mixin _$Variable {
  String get id => throw _privateConstructorUsedError;
  String get notebookId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  String? get expressionId => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Variable to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Variable
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VariableCopyWith<Variable> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VariableCopyWith<$Res> {
  factory $VariableCopyWith(Variable value, $Res Function(Variable) then) =
      _$VariableCopyWithImpl<$Res, Variable>;
  @useResult
  $Res call(
      {String id,
      String notebookId,
      String name,
      String value,
      String? expressionId,
      DateTime updatedAt});
}

/// @nodoc
class _$VariableCopyWithImpl<$Res, $Val extends Variable>
    implements $VariableCopyWith<$Res> {
  _$VariableCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Variable
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? notebookId = null,
    Object? name = null,
    Object? value = null,
    Object? expressionId = freezed,
    Object? updatedAt = null,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      expressionId: freezed == expressionId
          ? _value.expressionId
          : expressionId // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VariableImplCopyWith<$Res>
    implements $VariableCopyWith<$Res> {
  factory _$$VariableImplCopyWith(
          _$VariableImpl value, $Res Function(_$VariableImpl) then) =
      __$$VariableImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String notebookId,
      String name,
      String value,
      String? expressionId,
      DateTime updatedAt});
}

/// @nodoc
class __$$VariableImplCopyWithImpl<$Res>
    extends _$VariableCopyWithImpl<$Res, _$VariableImpl>
    implements _$$VariableImplCopyWith<$Res> {
  __$$VariableImplCopyWithImpl(
      _$VariableImpl _value, $Res Function(_$VariableImpl) _then)
      : super(_value, _then);

  /// Create a copy of Variable
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? notebookId = null,
    Object? name = null,
    Object? value = null,
    Object? expressionId = freezed,
    Object? updatedAt = null,
  }) {
    return _then(_$VariableImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      notebookId: null == notebookId
          ? _value.notebookId
          : notebookId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      expressionId: freezed == expressionId
          ? _value.expressionId
          : expressionId // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VariableImpl implements _Variable {
  const _$VariableImpl(
      {required this.id,
      required this.notebookId,
      required this.name,
      required this.value,
      this.expressionId,
      required this.updatedAt});

  factory _$VariableImpl.fromJson(Map<String, dynamic> json) =>
      _$$VariableImplFromJson(json);

  @override
  final String id;
  @override
  final String notebookId;
  @override
  final String name;
  @override
  final String value;
  @override
  final String? expressionId;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Variable(id: $id, notebookId: $notebookId, name: $name, value: $value, expressionId: $expressionId, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VariableImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.notebookId, notebookId) ||
                other.notebookId == notebookId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.expressionId, expressionId) ||
                other.expressionId == expressionId) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, notebookId, name, value, expressionId, updatedAt);

  /// Create a copy of Variable
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VariableImplCopyWith<_$VariableImpl> get copyWith =>
      __$$VariableImplCopyWithImpl<_$VariableImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VariableImplToJson(
      this,
    );
  }
}

abstract class _Variable implements Variable {
  const factory _Variable(
      {required final String id,
      required final String notebookId,
      required final String name,
      required final String value,
      final String? expressionId,
      required final DateTime updatedAt}) = _$VariableImpl;

  factory _Variable.fromJson(Map<String, dynamic> json) =
      _$VariableImpl.fromJson;

  @override
  String get id;
  @override
  String get notebookId;
  @override
  String get name;
  @override
  String get value;
  @override
  String? get expressionId;
  @override
  DateTime get updatedAt;

  /// Create a copy of Variable
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VariableImplCopyWith<_$VariableImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
