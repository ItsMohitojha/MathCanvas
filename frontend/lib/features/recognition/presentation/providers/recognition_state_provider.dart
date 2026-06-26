import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mathcanvas/core/constants/app_constants.dart';
import 'package:mathcanvas/core/utils/debouncer.dart';
import 'package:mathcanvas/features/canvas/presentation/providers/canvas_state_provider.dart';
import 'package:mathcanvas/features/canvas/domain/models/stroke.dart';
import 'package:mathcanvas/features/recognition/domain/models/recognized_expression.dart';
import 'package:mathcanvas/features/recognition/domain/repositories/expression_repository.dart';
import 'package:mathcanvas/features/recognition/domain/engines/recognition_engine.dart';
import 'package:mathcanvas/features/recognition/data/datasources/expression_local_datasource.dart';
import 'package:mathcanvas/features/recognition/data/repositories/expression_repository_impl.dart';
import 'package:mathcanvas/features/recognition/data/engines/tflite_recognition_engine.dart';
import 'package:mathcanvas/shared/database/database_provider.dart';
import 'package:mathcanvas/core/utils/uuid_generator.dart';

part 'recognition_state_provider.freezed.dart';

/// Immutable state for the handwriting recognition pipeline.
@freezed
class RecognitionState with _$RecognitionState {
  const factory RecognitionState({
    @Default(<RecognizedExpression>[]) List<RecognizedExpression> expressions,
    @Default(false) bool isPending,
    String? error,
  }) = _RecognitionState;
}

/// Provider for the expression local data source.
final expressionLocalDatasourceProvider = Provider<ExpressionLocalDatasource>((ref) {
  final dbFuture = ref.watch(databaseProvider);
  return ExpressionLocalDatasourceImpl(dbFuture);
});

/// Provider for the expression repository.
final expressionRepositoryProvider = Provider<ExpressionRepository>((ref) {
  final localDatasource = ref.watch(expressionLocalDatasourceProvider);
  return ExpressionRepositoryImpl(localDatasource);
});

/// Provider for the recognition engine.
final recognitionEngineProvider = Provider<RecognitionEngine>((ref) {
  return TFLiteRecognitionEngine();
});

/// Riverpod provider managing the handwriting recognition state.
final recognitionStateProvider =
    NotifierProvider<RecognitionStateNotifier, RecognitionState>(
  RecognitionStateNotifier.new,
);

/// Riverpod Notifier managing the recognition pipeline.
///
/// Listens to [canvasStateProvider] to reactively trigger recognition
/// when strokes change. Persists results to SQLite.
class RecognitionStateNotifier extends Notifier<RecognitionState> {
  Debouncer? _debouncer;
  String? _lastNotebookId;

  @override
  RecognitionState build() {
    _debouncer ??= Debouncer(
      delay: const Duration(milliseconds: AppConstants.recognitionIdleTimeoutMs),
    );

    final canvasState = ref.watch(canvasStateProvider);
    final notebookId = canvasState.currentNotebookId;
    final strokes = canvasState.strokes;

    if (notebookId != null) {
      if (_lastNotebookId != notebookId) {
        _lastNotebookId = notebookId;
        // Notebook changed: load expressions from database.
        Future.microtask(() => _loadExpressions(notebookId));
      } else {
        // Strokes changed: trigger/reset debounced recognition.
        _debouncer!.run(() => runRecognition(notebookId, strokes));
      }
    } else {
      _lastNotebookId = null;
      _debouncer!.cancel();
    }

    ref.onDispose(() {
      _debouncer?.cancel();
    });

    return const RecognitionState();
  }

  Future<void> _loadExpressions(String notebookId) async {
    state = state.copyWith(isPending: true);
    try {
      final repository = ref.read(expressionRepositoryProvider);
      final expressions = await repository.getExpressions(notebookId);
      state = state.copyWith(
        expressions: expressions,
        isPending: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isPending: false,
        error: e.toString(),
      );
    }
  }

  /// Manually triggers recognition for the given [strokes].
  Future<void> runRecognition(String notebookId, List<Stroke> strokes) async {
    if (strokes.isEmpty) {
      final repository = ref.read(expressionRepositoryProvider);
      await repository.replaceExpressions(notebookId, []);
      state = state.copyWith(expressions: [], isPending: false, error: null);
      return;
    }

    state = state.copyWith(isPending: true);

    try {
      final engine = ref.read(recognitionEngineProvider);
      final repository = ref.read(expressionRepositoryProvider);

      // 1. Group strokes by spatial proximity
      final groups = groupStrokes(strokes, AppConstants.groupingThreshold);
      final List<RecognizedExpression> recognizedExpressions = [];

      // 2. Send each group to the recognition engine
      for (final group in groups) {
        final results = await engine.recognize(group);
        if (results.isEmpty) continue;
        final result = results.first;

        if (result.latex == '?') continue;

        double minX = double.infinity;
        double minY = double.infinity;
        double maxX = -double.infinity;
        double maxY = -double.infinity;

        for (final s in group) {
          final bbox = s.boundingBox;
          if (bbox.left < minX) minX = bbox.left;
          if (bbox.top < minY) minY = bbox.top;
          if (bbox.right > maxX) maxX = bbox.right;
          if (bbox.bottom > maxY) maxY = bbox.bottom;
        }

        final now = DateTime.now();

        // Check if there was already an expression for these strokes to preserve ID
        final existingExprIndex = state.expressions.indexWhere(
          (e) => _listEquals(e.strokeIds, result.strokeIds),
        );

        final RecognizedExpression expression;
        if (existingExprIndex != -1) {
          final existing = state.expressions[existingExprIndex];
          expression = existing.copyWith(
            rawLatex: result.latex,
            confidence: result.confidence,
            bboxMinX: minX,
            bboxMinY: minY,
            bboxMaxX: maxX,
            bboxMaxY: maxY,
            updatedAt: now,
          );
        } else {
          expression = RecognizedExpression(
            id: UuidGenerator.generateV4(),
            notebookId: notebookId,
            rawLatex: result.latex,
            confidence: result.confidence,
            bboxMinX: minX,
            bboxMinY: minY,
            bboxMaxX: maxX,
            bboxMaxY: maxY,
            createdAt: now,
            updatedAt: now,
            strokeIds: result.strokeIds,
          );
        }

        recognizedExpressions.add(expression);
      }

      // 3. Persist to database inside a single transaction
      await repository.replaceExpressions(notebookId, recognizedExpressions);

      state = state.copyWith(
        expressions: recognizedExpressions,
        isPending: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isPending: false,
        error: e.toString(),
      );
    }
  }

  /// Groups strokes into spatial clusters using bounding box intersections.
  List<List<Stroke>> groupStrokes(List<Stroke> strokes, double threshold) {
    if (strokes.isEmpty) return [];

    final groups = strokes.map((s) => [s]).toList();
    bool mergedAny = true;

    while (mergedAny) {
      mergedAny = false;
      for (int i = 0; i < groups.length; i++) {
        for (int j = i + 1; j < groups.length; j++) {
          if (_shouldMerge(groups[i], groups[j], threshold)) {
            groups[i].addAll(groups[j]);
            groups.removeAt(j);
            mergedAny = true;
            break;
          }
        }
        if (mergedAny) break;
      }
    }

    return groups;
  }

  bool _shouldMerge(List<Stroke> groupA, List<Stroke> groupB, double threshold) {
    for (final sA in groupA) {
      final rA = sA.boundingBox;
      for (final sB in groupB) {
        final rB = sB.boundingBox;
        if (rA.inflate(threshold / 2).overlaps(rB.inflate(threshold / 2))) {
          return true;
        }
      }
    }
    return false;
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    final sortedA = List<String>.from(a)..sort();
    final sortedB = List<String>.from(b)..sort();
    for (int i = 0; i < sortedA.length; i++) {
      if (sortedA[i] != sortedB[i]) return false;
    }
    return true;
  }
}
