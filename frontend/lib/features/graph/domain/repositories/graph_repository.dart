import '../models/graph_data.dart';

/// Repository contract managing graph generation, caching, and lifecycle.
abstract class GraphRepository {
  /// Generates a graph by calling the backend API and persists the result locally.
  ///
  /// Returns the [GraphData] domain model on success.
  Future<GraphData> generateGraph(
    String expressionId,
    String expression, {
    String variable = 'x',
    double xRangeMin = -10.0,
    double xRangeMax = 10.0,
    int numPoints = 500,
  });

  /// Retrieves all cached graphs for a notebook from local storage.
  Future<List<GraphData>> getCachedGraphs(String notebookId);

  /// Retrieves a cached graph for a specific expression from local storage.
  Future<GraphData?> getCachedGraphByExpressionId(String expressionId);

  /// Saves a graph to local storage.
  Future<void> saveGraph(GraphData graph);

  /// Deletes a graph for a given expression from local storage.
  Future<void> deleteGraph(String expressionId);

  /// Deletes all graphs for a notebook from local storage.
  Future<void> deleteAllGraphs(String notebookId);
}
