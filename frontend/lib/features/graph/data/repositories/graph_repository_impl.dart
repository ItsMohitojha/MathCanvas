import 'package:mathcanvas/core/utils/uuid_generator.dart';
import '../../domain/models/graph_data.dart';
import '../../domain/repositories/graph_repository.dart';
import '../datasources/graph_api_client.dart';
import '../datasources/graph_local_datasource.dart';
import '../models/graph_entity.dart';

/// Concrete implementation of the [GraphRepository].
class GraphRepositoryImpl implements GraphRepository {
  final GraphApiClient _apiClient;
  final GraphLocalDatasource _localDatasource;

  /// Creates a [GraphRepositoryImpl].
  GraphRepositoryImpl(this._apiClient, this._localDatasource);

  @override
  Future<GraphData> generateGraph(
    String expressionId,
    String expression, {
    String variable = 'x',
    double xRangeMin = -10.0,
    double xRangeMax = 10.0,
    int numPoints = 500,
  }) async {
    final response = await _apiClient.generateGraph(
      expression,
      variable: variable,
      xRange: [xRangeMin, xRangeMax],
      numPoints: numPoints,
    );

    final success = response['success'] as bool;
    final now = DateTime.now();

    if (success) {
      final result = response['result'] as Map<String, dynamic>;
      final data = result['data'] as Map<String, dynamic>;

      final xList = (data['x'] as List).map((e) => (e as num).toDouble()).toList();
      final yList = (data['y'] as List)
          .map((e) => e != null ? (e as num).toDouble() : null)
          .toList();

      final graphData = GraphData(
        id: UuidGenerator.generateV4(),
        expressionId: expressionId,
        variable: variable,
        xRangeMin: xRangeMin,
        xRangeMax: xRangeMax,
        numPoints: numPoints,
        xValues: xList,
        yValues: yList,
        title: data['title'] as String? ?? 'Graph',
        color: data['color'] as String? ?? '#6366f1',
        generatedAt: now,
      );

      // Persist to local DB
      await _localDatasource.saveGraph(GraphEntity.fromDomain(graphData));

      return graphData;
    } else {
      final err = response['error'] as Map<String, dynamic>;
      throw Exception('Graph generation failed: ${err['message']}');
    }
  }

  @override
  Future<List<GraphData>> getCachedGraphs(String notebookId) async {
    final entities = await _localDatasource.getGraphs(notebookId);
    return entities.map((e) => e.toDomain()).toList();
  }

  @override
  Future<GraphData?> getCachedGraphByExpressionId(String expressionId) async {
    final entity = await _localDatasource.getGraphByExpressionId(expressionId);
    return entity?.toDomain();
  }

  @override
  Future<void> saveGraph(GraphData graph) async {
    await _localDatasource.saveGraph(GraphEntity.fromDomain(graph));
  }

  @override
  Future<void> deleteGraph(String expressionId) async {
    await _localDatasource.deleteGraph(expressionId);
  }

  @override
  Future<void> deleteAllGraphs(String notebookId) async {
    await _localDatasource.deleteAllGraphs(notebookId);
  }
}
