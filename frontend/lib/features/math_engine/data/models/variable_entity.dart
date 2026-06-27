import '../../domain/models/variable.dart';

/// Database Transfer Object for the variables table.
class VariableEntity {
  final String id;
  final String notebookId;
  final String name;
  final String value;
  final String? expressionId;
  final int updatedAt;

  /// Creates a [VariableEntity].
  VariableEntity({
    required this.id,
    required this.notebookId,
    required this.name,
    required this.value,
    this.expressionId,
    required this.updatedAt,
  });

  /// Converts this entity to a map for database insertion.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'notebook_id': notebookId,
      'name': name,
      'value': value,
      'expression_id': expressionId,
      'updated_at': updatedAt,
    };
  }

  /// Creates a [VariableEntity] from a database map.
  factory VariableEntity.fromMap(Map<String, dynamic> map) {
    return VariableEntity(
      id: map['id'] as String,
      notebookId: map['notebook_id'] as String,
      name: map['name'] as String,
      value: map['value'] as String,
      expressionId: map['expression_id'] as String?,
      updatedAt: map['updated_at'] as int,
    );
  }

  /// Converts this entity to a domain model.
  Variable toDomain() {
    return Variable(
      id: id,
      notebookId: notebookId,
      name: name,
      value: value,
      expressionId: expressionId,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
    );
  }

  /// Creates a [VariableEntity] from a domain model.
  factory VariableEntity.fromDomain(Variable domain) {
    return VariableEntity(
      id: domain.id,
      notebookId: domain.notebookId,
      name: domain.name,
      value: domain.value,
      expressionId: domain.expressionId,
      updatedAt: domain.updatedAt.millisecondsSinceEpoch,
    );
  }
}
