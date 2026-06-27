import 'package:flutter_test/flutter_test.dart';
import 'package:mathcanvas/features/graph/data/datasources/graph_api_client.dart';
import 'package:mathcanvas/features/graph/data/datasources/graph_local_datasource.dart';
import 'package:mathcanvas/features/graph/data/models/graph_entity.dart';
import 'package:mathcanvas/features/graph/data/repositories/graph_repository_impl.dart';
import 'package:mathcanvas/features/graph/domain/models/graph_data.dart';

class FakeGraphApiClient implements GraphApiClient {
  Map<String, dynamic>? mockResponse;

  @override
  Future<Map<String, dynamic>> generateGraph(
    String expression, {
    String variable = 'x',
    List<double> xRange = const [-10.0, 10.0],
    int numPoints = 500,
    Map<String, dynamic>? style,
  }) async {
    return mockResponse ?? {
      'success': true,
      'result': {
        'data': {
          'x': [1.0, 2.0],
          'y': [1.0, 4.0],
          'title': 'y = x^2',
          'color': '#6366f1',
        }
      }
    };
  }
}

class FakeGraphLocalDatasource implements GraphLocalDatasource {
  final Map<String, GraphEntity> graphs = {};
  final Map<String, String> graphNotebooks = {}; // Maps expressionId to notebookId

  @override
  Future<List<GraphEntity>> getGraphs(String notebookId) async {
    final list = <GraphEntity>[];
    graphs.forEach((exprId, entity) {
      if (graphNotebooks[exprId] == notebookId) {
        list.add(entity);
      }
    });
    return list;
  }

  @override
  Future<GraphEntity?> getGraphByExpressionId(String expressionId) async {
    return graphs[expressionId];
  }

  @override
  Future<void> saveGraph(GraphEntity graph) async {
    graphs[graph.expressionId] = graph;
    // Map to nb_1 by default
    graphNotebooks[graph.expressionId] ??= 'nb_1';
  }

  @override
  Future<void> deleteGraph(String expressionId) async {
    graphs.remove(expressionId);
    graphNotebooks.remove(expressionId);
  }

  @override
  Future<void> deleteAllGraphs(String notebookId) async {
    graphNotebooks.removeWhere((exprId, nbId) => nbId == notebookId);
    graphs.removeWhere((exprId, entity) => !graphNotebooks.containsKey(exprId));
  }
}

void main() {
  group('GraphRepositoryImpl Tests', () {
    late FakeGraphApiClient fakeApiClient;
    late FakeGraphLocalDatasource fakeLocalDatasource;
    late GraphRepositoryImpl repository;

    setUp(() {
      fakeApiClient = FakeGraphApiClient();
      fakeLocalDatasource = FakeGraphLocalDatasource();
      repository = GraphRepositoryImpl(fakeApiClient, fakeLocalDatasource);
    });

    test('generateGraph handles success and saves/returns GraphData', () async {
      final result = await repository.generateGraph('expr_1', 'y = x^2');
      
      expect(result.expressionId, equals('expr_1'));
      expect(result.title, equals('y = x^2'));
      expect(result.xValues, equals([1.0, 2.0]));
      expect(result.yValues, equals([1.0, 4.0]));
      
      // Verify saved to local cache
      final cached = await repository.getCachedGraphByExpressionId('expr_1');
      expect(cached, isNotNull);
      expect(cached!.title, equals('y = x^2'));
    });

    test('generateGraph handles API error by throwing Exception', () async {
      fakeApiClient.mockResponse = {
        'success': false,
        'error': {'message': 'SymPy evaluation timeout'}
      };

      expect(
        () => repository.generateGraph('expr_2', 'y = tan(x)'),
        throwsA(isA<Exception>()),
      );
    });

    test('cache operations get, save, delete work as expected', () async {
      final mockData = GraphData(
        id: 'graph_1',
        expressionId: 'expr_3',
        xValues: [1.0, 2.0],
        yValues: [1.0, 2.0],
        title: 'Cached Graph',
        generatedAt: DateTime.now(),
      );

      // Save Graph Entity
      await repository.saveGraph(mockData);
      
      final retrieved = await repository.getCachedGraphByExpressionId('expr_3');
      expect(retrieved, isNotNull);
      expect(retrieved!.title, equals('Cached Graph'));

      // Delete Graph
      await repository.deleteGraph('expr_3');
      final retrievedAfter = await repository.getCachedGraphByExpressionId('expr_3');
      expect(retrievedAfter, isNull);
    });

    test('deleteAllGraphs clears cache for notebook', () async {
      final mockData = GraphData(
        id: 'graph_1',
        expressionId: 'expr_3',
        xValues: [1.0, 2.0],
        yValues: [1.0, 2.0],
        title: 'Cached Graph',
        generatedAt: DateTime.now(),
      );

      await repository.saveGraph(mockData);
      // Map it in the fake
      fakeLocalDatasource.graphNotebooks['expr_3'] = 'nb_1';

      await repository.deleteAllGraphs('nb_1');
      final list = await repository.getCachedGraphs('nb_1');
      expect(list.isEmpty, isTrue);
    });
  });
}
