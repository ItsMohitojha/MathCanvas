import '../models/recognized_expression.dart';

/// Repository contract managing SQLite database storage for recognized expressions.
abstract class ExpressionRepository {
  /// Gets all recognized expressions for the given [notebookId].
  Future<List<RecognizedExpression>> getExpressions(String notebookId);

  /// Saves or updates the given [expression].
  Future<void> saveExpression(RecognizedExpression expression);

  /// Deletes the expression with the given [id].
  Future<void> deleteExpression(String id);

  /// Replaces all expressions for the notebook with the new list in a single transaction.
  Future<void> replaceExpressions(String notebookId, List<RecognizedExpression> expressions);
}
