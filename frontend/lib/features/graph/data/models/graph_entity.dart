import 'dart:convert';
import '../../domain/models/graph_data.dart';

/// Database Transfer Object for the graphs table.
class GraphEntity {
  final String id;
  final String expressionId;
  final String graphDataJson;
  final String variable;
  final double xRangeMin;
  final double xRangeMax;
  final int numPoints;
  final int generatedAt;

  /// Creates a [GraphEntity].
  GraphEntity({
    required this.id,
    required this.expressionId,
    required this.graphDataJson,
    required this.variable,
    required this.xRangeMin,
    required this.xRangeMax,
    required this.numPoints,
    required this.generatedAt,
  });

  /// Converts this entity to a map for database insertion.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expression_id': expressionId,
      'graph_data_json': graphDataJson,
      'variable': variable,
      'x_range_min': xRangeMin,
      'x_range_max': xRangeMax,
      'num_points': numPoints,
      'generated_at': generatedAt,
    };
  }

  /// Creates a [GraphEntity] from a database row map.
  factory GraphEntity.fromMap(Map<String, dynamic> map) {
    return GraphEntity(
      id: map['id'] as String,
      expressionId: map['expression_id'] as String,
      graphDataJson: map['graph_data_json'] as String,
      variable: map['variable'] as String,
      xRangeMin: (map['x_range_min'] as num).toDouble(),
      xRangeMax: (map['x_range_max'] as num).toDouble(),
      numPoints: map['num_points'] as int,
      generatedAt: map['generated_at'] as int,
    );
  }

  /// Converts this entity to a [GraphData] domain model.
  GraphData toDomain() {
    final dataMap = json.decode(graphDataJson) as Map<String, dynamic>;
    final xList = (dataMap['x'] as List).map((e) => (e as num).toDouble()).toList();
    final yList = (dataMap['y'] as List)
        .map((e) => e != null ? (e as num).toDouble() : null)
        .toList();

    return GraphData(
      id: id,
      expressionId: expressionId,
      variable: variable,
      xRangeMin: xRangeMin,
      xRangeMax: xRangeMax,
      numPoints: numPoints,
      xValues: xList,
      yValues: yList,
      title: dataMap['title'] as String? ?? 'Graph',
      color: dataMap['color'] as String? ?? '#6366f1',
      generatedAt: DateTime.fromMillisecondsSinceEpoch(generatedAt),
    );
  }

  /// Creates a [GraphEntity] from a [GraphData] domain model.
  factory GraphEntity.fromDomain(GraphData domain) {
    final dataMap = {
      'x': domain.xValues,
      'y': domain.yValues,
      'x_label': domain.variable,
      'y_label': 'y',
      'title': domain.title,
      'color': domain.color,
    };

    return GraphEntity(
      id: domain.id,
      expressionId: domain.expressionId,
      graphDataJson: json.encode(dataMap),
      variable: domain.variable,
      xRangeMin: domain.xRangeMin,
      xRangeMax: domain.xRangeMax,
      numPoints: domain.numPoints,
      generatedAt: domain.generatedAt.millisecondsSinceEpoch,
    );
  }
}
