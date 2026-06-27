import 'package:dio/dio.dart';

/// HTTP Client that communicates with the local FastAPI graph generation backend.
class GraphApiClient {
  final Dio _dio;

  /// Creates a [GraphApiClient].
  GraphApiClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'http://127.0.0.1:8400',
                connectTimeout: const Duration(seconds: 5),
                receiveTimeout: const Duration(seconds: 15),
                headers: {
                  'Content-Type': 'application/json',
                },
              ),
            );

  /// Calls the graph generation endpoint.
  ///
  /// Returns the raw JSON response map from the API.
  Future<Map<String, dynamic>> generateGraph(
    String expression, {
    String variable = 'x',
    List<double> xRange = const [-10.0, 10.0],
    int numPoints = 500,
    Map<String, dynamic>? style,
  }) async {
    try {
      final response = await _dio.post(
        '/api/v1/graph',
        data: {
          'expression': expression,
          'variable': variable,
          'x_range': xRange,
          'num_points': numPoints,
          'output_format': 'data',
          if (style != null) 'style': style,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception('API error calling graph: ${e.message}');
    }
  }
}
