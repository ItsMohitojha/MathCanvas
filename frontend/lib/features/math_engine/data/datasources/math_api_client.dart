import 'package:dio/dio.dart';

/// HTTP Client that communicates with the local FastAPI mathematical backend.
class MathApiClient {
  final Dio _dio;

  /// Creates a [MathApiClient].
  MathApiClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'http://127.0.0.1:8400',
                connectTimeout: const Duration(seconds: 5),
                receiveTimeout: const Duration(seconds: 10),
                headers: {
                  'Content-Type': 'application/json',
                },
              ),
            );

  /// Calls the parse endpoint.
  Future<Map<String, dynamic>> parse(String expression) async {
    try {
      final response = await _dio.post(
        '/api/v1/parse',
        data: {'expression': expression},
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception('API error calling parse: ${e.message}');
    }
  }

  /// Calls the evaluate endpoint.
  Future<Map<String, dynamic>> evaluate(String expression, {Map<String, String>? symbolTable}) async {
    try {
      final response = await _dio.post(
        '/api/v1/evaluate',
        data: {
          'expression': expression,
          'symbol_table': symbolTable,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception('API error calling evaluate: ${e.message}');
    }
  }

  /// Calls the solve endpoint.
  Future<Map<String, dynamic>> solve(String expression, List<String> variables, {Map<String, String>? symbolTable}) async {
    try {
      final response = await _dio.post(
        '/api/v1/solve',
        data: {
          'expression': expression,
          'variables': variables,
          'operation': 'solve',
          'symbol_table': symbolTable,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception('API error calling solve: ${e.message}');
    }
  }

  /// Calls the simplify endpoint.
  Future<Map<String, dynamic>> simplify(String expression, {Map<String, String>? symbolTable}) async {
    try {
      final response = await _dio.post(
        '/api/v1/simplify',
        data: {
          'expression': expression,
          'symbol_table': symbolTable,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception('API error calling simplify: ${e.message}');
    }
  }
}
