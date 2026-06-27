import '../models/math_result.dart';
import '../models/variable.dart';

/// Repository contract managing mathematical calculations and local persistence.
abstract class MathRepository {
  /// Parses a LaTeX expression. Returns raw JSON map from parser endpoint.
  Future<Map<String, dynamic>> parse(String expression);

  /// Evaluates an arithmetic expression and returns a [MathResult].
  Future<MathResult> evaluate(String expressionId, String expression, {Map<String, String>? symbolTable});

  /// Solves an algebraic equation for variables and returns a [MathResult].
  Future<MathResult> solve(String expressionId, String expression, List<String> variables, {Map<String, String>? symbolTable});

  /// Simplifies a symbolic expression and returns a [MathResult].
  Future<MathResult> simplify(String expressionId, String expression, {Map<String, String>? symbolTable});

  /// Retrieves cached results for a notebook from local database.
  Future<List<MathResult>> getCachedResults(String notebookId);

  /// Retrieves cached variables for a notebook from local database.
  Future<List<Variable>> getCachedVariables(String notebookId);

  /// Saves a computed result locally.
  Future<void> saveResult(MathResult result);

  /// Saves a variable locally.
  Future<void> saveVariable(Variable variable);

  /// Deletes a result locally.
  Future<void> deleteResult(String expressionId);

  /// Deletes a variable locally.
  Future<void> deleteVariable(String name, String notebookId);

  /// Transactionally replaces results and variables.
  Future<void> replaceResultsAndVariables({
    required String notebookId,
    required List<MathResult> results,
    required List<Variable> variables,
  });
}
