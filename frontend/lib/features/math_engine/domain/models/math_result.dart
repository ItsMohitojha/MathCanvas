import 'package:freezed_annotation/freezed_annotation.dart';

part 'math_result.freezed.dart';
part 'math_result.g.dart';

/// Immutable domain model representing a math evaluation/solution result.
@freezed
class MathResult with _$MathResult {
  const factory MathResult({
    required String id,
    required String expressionId,
    required String resultType, // 'numeric', 'solution', 'simplified', 'error'
    required String value,
    required String latex,
    double? numericValue,
    required DateTime computedAt,
  }) = _MathResult;

  const MathResult._();

  /// Creates a [MathResult] from a JSON map.
  factory MathResult.fromJson(Map<String, dynamic> json) =>
      _$MathResultFromJson(json);

  /// Helper to check if result is an error.
  bool get isError => resultType == 'error';

  /// Helper to check if result is a solution.
  bool get isSolution => resultType == 'solution';

  /// Helper to check if result is numeric.
  bool get isNumeric => resultType == 'numeric';

  /// Helper to check if result is simplified expression.
  bool get isSimplified => resultType == 'simplified';
}
