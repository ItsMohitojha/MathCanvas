import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/math_result.dart';

part 'math_state.freezed.dart';
part 'math_state.g.dart';

/// Immutable state managing active computation results, symbol tables, and variable dependency trees.
@freezed
class MathState with _$MathState {
  const factory MathState({
    @Default(<String, MathResult>{}) Map<String, MathResult> results,
    @Default(<String, String>{}) Map<String, String> symbolTable,
    @Default(<String, Set<String>>{}) Map<String, Set<String>> dependencies,
    @Default(<String, String>{}) Map<String, String> definedVariables,
    @Default(false) bool isPending,
    String? error,
  }) = _MathState;

  /// Creates a [MathState] from a JSON map.
  factory MathState.fromJson(Map<String, dynamic> json) =>
      _$MathStateFromJson(json);
}
