import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mathcanvas/shared/database/database_provider.dart';
import 'package:mathcanvas/features/recognition/presentation/providers/recognition_state_provider.dart';
import 'package:mathcanvas/features/recognition/domain/models/recognized_expression.dart';
import 'graph_state.dart';
import '../../domain/models/graph_data.dart';
import '../../domain/repositories/graph_repository.dart';
import '../../data/datasources/graph_api_client.dart';
import '../../data/datasources/graph_local_datasource.dart';
import '../../data/repositories/graph_repository_impl.dart';

/// Provider for the Graph API Client.
final graphApiClientProvider = Provider<GraphApiClient>((ref) {
  return GraphApiClient();
});

/// Provider for the Graph Local Datasource.
final graphLocalDatasourceProvider = Provider<GraphLocalDatasource>((ref) {
  final dbFuture = ref.watch(databaseProvider);
  return GraphLocalDatasourceImpl(dbFuture);
});

/// Provider for the Graph Repository.
final graphRepositoryProvider = Provider<GraphRepository>((ref) {
  final api = ref.watch(graphApiClientProvider);
  final local = ref.watch(graphLocalDatasourceProvider);
  return GraphRepositoryImpl(api, local);
});

/// Riverpod provider managing the Graph Engine state.
final graphStateProvider = NotifierProvider<GraphStateNotifier, GraphState>(
  GraphStateNotifier.new,
);

/// Notifier that manages graph generation, caching, and auto-refresh.
///
/// Watches the recognition state for function-type expressions and
/// automatically generates graphs for them. Refreshes graphs when
/// the underlying expression changes.
class GraphStateNotifier extends Notifier<GraphState> {
  String? _lastNotebookId;

  /// Set of expression IDs for which graphs have been generated or are in-flight.
  final Set<String> _processedExpressionIds = {};

  @override
  GraphState build() {
    final recognitionState = ref.watch(recognitionStateProvider);
    final expressions = recognitionState.expressions;

    // Determine current notebook ID
    final notebookId =
        expressions.isNotEmpty ? expressions.first.notebookId : null;

    if (notebookId != null) {
      if (_lastNotebookId != notebookId) {
        _lastNotebookId = notebookId;
        _processedExpressionIds.clear();
        Future.microtask(() => _loadNotebookGraphs(notebookId));
      } else {
        // Expressions list changed — process new function expressions
        Future.microtask(() => _processExpressionsDelta(expressions));
      }
    } else {
      _lastNotebookId = null;
      _processedExpressionIds.clear();
    }

    return const GraphState();
  }

  /// Loads cached graphs from local database when a notebook is opened.
  Future<void> _loadNotebookGraphs(String notebookId) async {
    try {
      final repo = ref.read(graphRepositoryProvider);
      final cachedGraphs = await repo.getCachedGraphs(notebookId);

      final graphMap = <String, GraphData>{};
      for (final graph in cachedGraphs) {
        graphMap[graph.expressionId] = graph;
        _processedExpressionIds.add(graph.expressionId);
      }

      if (graphMap.isNotEmpty) {
        state = state.copyWith(graphs: graphMap);
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to load cached graphs: $e');
    }
  }

  /// Processes changes in the expression list.
  ///
  /// Generates graphs for new function-type expressions that haven't been
  /// processed yet. Removes graphs for expressions that no longer exist.
  Future<void> _processExpressionsDelta(
    List<RecognizedExpression> expressions,
  ) async {
    // Find function-type expressions not yet processed
    final functionExpressions = expressions.where(
      (e) => e.expressionType == 'function' && !_processedExpressionIds.contains(e.id),
    );

    for (final expr in functionExpressions) {
      await _generateGraphForExpression(expr);
    }

    // Remove graphs for expressions that no longer exist
    final currentIds = expressions.map((e) => e.id).toSet();
    final removedIds = _processedExpressionIds
        .where((id) => !currentIds.contains(id))
        .toList();

    if (removedIds.isNotEmpty) {
      final updatedGraphs = Map<String, GraphData>.from(state.graphs);
      for (final id in removedIds) {
        updatedGraphs.remove(id);
        _processedExpressionIds.remove(id);
      }
      state = state.copyWith(graphs: updatedGraphs);
    }
  }

  /// Generates a graph for a single function expression.
  Future<void> _generateGraphForExpression(
    RecognizedExpression expression,
  ) async {
    _processedExpressionIds.add(expression.id);

    state = state.copyWith(isPending: true, error: null);

    try {
      final repo = ref.read(graphRepositoryProvider);
      final graphExpression = expression.parsedExpression ?? expression.rawLatex;

      final graphData = await repo.generateGraph(
        expression.id,
        graphExpression,
      );

      final updatedGraphs = Map<String, GraphData>.from(state.graphs);
      updatedGraphs[expression.id] = graphData;
      state = state.copyWith(graphs: updatedGraphs, isPending: false);
    } catch (e) {
      state = state.copyWith(
        isPending: false,
        error: 'Failed to generate graph: $e',
      );
    }
  }

  /// Manually refreshes a graph for a given expression.
  ///
  /// Called when an expression is updated and its graph needs regeneration.
  Future<void> refreshGraph(
    String expressionId,
    String expression, {
    String variable = 'x',
    double xRangeMin = -10.0,
    double xRangeMax = 10.0,
    int numPoints = 500,
  }) async {
    state = state.copyWith(isPending: true, error: null);

    try {
      final repo = ref.read(graphRepositoryProvider);
      final graphData = await repo.generateGraph(
        expressionId,
        expression,
        variable: variable,
        xRangeMin: xRangeMin,
        xRangeMax: xRangeMax,
        numPoints: numPoints,
      );

      final updatedGraphs = Map<String, GraphData>.from(state.graphs);
      updatedGraphs[expressionId] = graphData;
      state = state.copyWith(graphs: updatedGraphs, isPending: false);
    } catch (e) {
      state = state.copyWith(
        isPending: false,
        error: 'Failed to refresh graph: $e',
      );
    }
  }

  /// Updates the viewport range for a graph (internal pan/zoom).
  void updateGraphRange(
    String expressionId, {
    required double xRangeMin,
    required double xRangeMax,
  }) {
    final existing = state.graphs[expressionId];
    if (existing == null) return;

    final updated = existing.copyWith(
      xRangeMin: xRangeMin,
      xRangeMax: xRangeMax,
    );

    final updatedGraphs = Map<String, GraphData>.from(state.graphs);
    updatedGraphs[expressionId] = updated;
    state = state.copyWith(graphs: updatedGraphs);
  }
}
