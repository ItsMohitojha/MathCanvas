import 'package:freezed_annotation/freezed_annotation.dart';

part 'variable.freezed.dart';
part 'variable.g.dart';

/// Immutable domain model representing a variable assignment in a notebook.
@freezed
class Variable with _$Variable {
  const factory Variable({
    required String id,
    required String notebookId,
    required String name,
    required String value,
    String? expressionId,
    required DateTime updatedAt,
  }) = _Variable;

  /// Creates a [Variable] from a JSON map.
  factory Variable.fromJson(Map<String, dynamic> json) =>
      _$VariableFromJson(json);
}
