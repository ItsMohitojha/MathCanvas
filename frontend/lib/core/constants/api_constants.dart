class ApiConstants {
  static const String baseUrl = 'http://127.0.0.1:8400';
  static const String healthPath = '/health';
  static const String parsePath = '/api/v1/parse';
  static const String solvePath = '/api/v1/solve';
  static const String evaluatePath = '/api/v1/evaluate';
  static const String simplifyPath = '/api/v1/simplify';
  static const String graphPath = '/api/v1/graph';
  
  static const Duration connectTimeout = Duration(seconds: 5);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
