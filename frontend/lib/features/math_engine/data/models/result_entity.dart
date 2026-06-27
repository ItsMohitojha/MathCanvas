import '../../domain/models/math_result.dart';

/// Database Transfer Object for the results table.
class ResultEntity {
  final String id;
  final String expressionId;
  final String resultType;
  final String value;
  final String latex;
  final double? numericValue;
  final int computedAt;

  /// Creates a [ResultEntity].
  ResultEntity({
    required this.id,
    required this.expressionId,
    required this.resultType,
    required this.value,
    required this.latex,
    this.numericValue,
    required this.computedAt,
  });

  /// Converts this entity to a map for database insertion.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expression_id': expressionId,
      'result_type': resultType,
      'value': value,
      'latex': latex,
      'numeric_value': numericValue,
      'computed_at': computedAt,
    };
  }

  /// Creates a [ResultEntity] from a database map.
  factory ResultEntity.fromMap(Map<String, dynamic> map) {
    return ResultEntity(
      id: map['id'] as String,
      expressionId: map['expression_id'] as String,
      resultType: map['result_type'] as String,
      value: map['value'] as String,
      latex: map['latex'] as String,
      numericValue: map['numeric_value'] != null ? (map['numeric_value'] as num).toDouble() : null,
      computedAt: map['computed_at'] as int,
    );
  }

  /// Converts this entity to a domain model.
  MathResult toDomain() {
    return MathResult(
      id: id,
      expressionId: expressionId,
      resultType: resultType,
      value: value,
      latex: latex,
      numericValue: numericValue,
      computedAt: DateTime.fromMillisecondsSinceEpoch(computedAt),
    );
  }

  /// Creates a [ResultEntity] from a domain model.
  factory ResultEntity.fromDomain(MathResult domain) {
    return ResultEntity(
      id: domain.id,
      expressionId: domain.expressionId,
      resultType: domain.resultType,
      value: domain.value,
      latex: domain.latex,
      numericValue: domain.numericValue,
      computedAt: domain.computedAt.millisecondsSinceEpoch,
    );
  }
}
