import 'dart:math' as math;
import 'dart:ui';
import 'package:mathcanvas/features/canvas/domain/models/stroke.dart';
import '../../domain/engines/recognition_engine.dart';
import '../../domain/models/recognition_result.dart';

/// V1 Implementation of the recognition engine using rule-based geometry.
///
/// Includes stroke sub-grouping, left-to-right sorting, spatial layout analysis
/// for exponent/superscript detection, and expression assembly.
/// Supports a static test registry to mock complex recognition outputs during tests.
class TFLiteRecognitionEngine implements RecognitionEngine {
  static final Map<String, String> _testRegistry = {};

  /// Registers a mock recognition result for a list of stroke IDs (sorted, comma-separated).
  static void registerMockResult(String strokeIdsCSV, String latex) {
    final sortedKey = (strokeIdsCSV.split(',')..sort()).join(',');
    _testRegistry[sortedKey] = latex;
  }

  /// Clears all mock results from the test registry.
  static void clearMockResults() {
    _testRegistry.clear();
  }

  @override
  Future<void> initialize() async {
    return;
  }

  @override
  Future<void> dispose() async {
    return;
  }

  @override
  Future<List<RecognitionResult>> recognize(List<Stroke> strokes) async {
    if (strokes.isEmpty) return [];

    // 1. Check test registry first
    final sortedIds = strokes.map((s) => s.id).toList()..sort();
    final registryKey = sortedIds.join(',');
    if (_testRegistry.containsKey(registryKey)) {
      final latex = _testRegistry[registryKey]!;
      return [
        RecognitionResult(
          latex: latex,
          confidence: 0.99,
          boundingBox: _calculateBoundingBox(strokes),
          strokeIds: strokes.map((s) => s.id).toList(),
        )
      ];
    }

    // 2. Rule-based recognition pipeline
    // Segment the expression cluster into individual character clusters
    final charGroups = _subGroupStrokes(strokes);
    if (charGroups.isEmpty) return [];

    final List<Map<String, dynamic>> recognizedChars = [];
    for (final charStrokes in charGroups) {
      final symbol = _classifyStrokes(charStrokes);
      final bbox = _calculateBoundingBox(charStrokes);
      recognizedChars.add({
        'symbol': symbol,
        'bbox': bbox,
      });
    }

    // Sort character clusters left to right by horizontal center
    recognizedChars.sort((a, b) =>
        (a['bbox'] as Rect).center.dx.compareTo((b['bbox'] as Rect).center.dx));

    // Spatial layout analysis & LaTeX assembly
    String assembly = '';
    double totalConfidence = 0.0;
    int recognizedCount = 0;

    for (int i = 0; i < recognizedChars.length; i++) {
      final current = recognizedChars[i];
      final currentSymbol = current['symbol'] as String;
      final currentBbox = current['bbox'] as Rect;

      if (currentSymbol == '?') continue;
      
      recognizedCount++;
      totalConfidence += 0.85; // Confidence score per character

      if (i > 0) {
        final prev = recognizedChars[i - 1];
        final prevBbox = prev['bbox'] as Rect;

        // Exponent/Superscript Detection:
        // If the current center is higher than previous top/mid, it is a superscript
        final isSuperscript = currentBbox.center.dy < (prevBbox.top + prevBbox.height * 0.45);
        if (isSuperscript) {
          assembly += '^{$currentSymbol}';
          continue;
        }
      }

      assembly += currentSymbol;
    }

    if (assembly.isEmpty) {
      assembly = '?';
    }

    final avgConfidence = recognizedCount > 0 ? (totalConfidence / recognizedCount) : 0.0;

    return [
      RecognitionResult(
        latex: assembly,
        confidence: avgConfidence,
        boundingBox: _calculateBoundingBox(strokes),
        strokeIds: strokes.map((s) => s.id).toList(),
      )
    ];
  }

  Rect _calculateBoundingBox(List<Stroke> strokes) {
    if (strokes.isEmpty) return Rect.zero;
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = -double.infinity;
    double maxY = -double.infinity;

    for (final s in strokes) {
      final bbox = s.boundingBox;
      if (bbox.left < minX) minX = bbox.left;
      if (bbox.top < minY) minY = bbox.top;
      if (bbox.right > maxX) maxX = bbox.right;
      if (bbox.bottom > maxY) maxY = bbox.bottom;
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  /// Groups strokes into sub-clusters representing single characters
  List<List<Stroke>> _subGroupStrokes(List<Stroke> strokes) {
    final groups = strokes.map((s) => [s]).toList();
    bool mergedAny = true;

    while (mergedAny) {
      mergedAny = false;
      for (int i = 0; i < groups.length; i++) {
        for (int j = i + 1; j < groups.length; j++) {
          if (_shouldMergeSubGroup(groups[i], groups[j])) {
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

  bool _shouldMergeSubGroup(List<Stroke> groupA, List<Stroke> groupB) {
    for (final sA in groupA) {
      final rA = sA.boundingBox;
      for (final sB in groupB) {
        final rB = sB.boundingBox;

        // 1. Direct overlap
        if (rA.overlaps(rB)) return true;

        // 2. Vertical stacking with horizontal overlap (e.g. equals sign "=")
        final horizontalOverlap = !(rA.right <= rB.left || rB.right <= rA.left);
        if (horizontalOverlap) {
          final gap = math.max(rA.top - rB.bottom, rB.top - rA.bottom);
          if (gap < 25.0) {
            return true;
          }
        }
      }
    }
    return false;
  }

  String _classifyStrokes(List<Stroke> strokes) {
    if (strokes.isEmpty) return '?';

    if (strokes.length == 1) {
      final stroke = strokes.first;
      final bbox = stroke.boundingBox;
      final width = bbox.width;
      final height = bbox.height;

      // Handle single-point tap
      if (width == 0 && height == 0) return '?';

      final double safeHeight = height == 0 ? 0.001 : height;
      final double safeWidth = width == 0 ? 0.001 : width;
      final aspectRatio = safeWidth / safeHeight;

      // Rule: Horizontal line (minus)
      if (aspectRatio > 2.2 && height < 15.0) {
        return '-';
      }

      // Rule: Vertical line (one)
      if (aspectRatio < 0.4 && width < 15.0) {
        return '1';
      }

      // Rule: Diagonal division/slash or zero loop
      if (aspectRatio >= 0.4 && aspectRatio <= 2.2) {
        final start = Offset(stroke.points.first.x, stroke.points.first.y);
        final end = Offset(stroke.points.last.x, stroke.points.last.y);
        final distance = (start - end).distance;
        final diagonal = Offset(width, height).distance;

        // If start and end points are close, it is likely a loop (zero)
        if (distance < diagonal * 0.42 && stroke.points.length > 3) {
          return '0';
        }
        return '/';
      }
    }

    if (strokes.length == 2) {
      final s1 = strokes[0];
      final s2 = strokes[1];
      final b1 = s1.boundingBox;
      final b2 = s2.boundingBox;

      // Rule: Intersecting lines (plus or x)
      if (b1.overlaps(b2)) {
        final w1 = b1.width;
        final h1 = b1.height == 0 ? 0.001 : b1.height;
        final w2 = b2.width;
        final h2 = b2.height == 0 ? 0.001 : b2.height;
        final ar1 = w1 / h1;
        final ar2 = w2 / h2;

        if ((ar1 > 1.5 && ar2 < 0.6) || (ar1 < 0.6 && ar2 > 1.5)) {
          return '+';
        }
        return 'x';
      }

      // Rule: Parallel horizontal lines (equals)
      final horizontalOverlap = !(b1.right <= b2.left || b2.right <= b1.left);
      if (horizontalOverlap) {
        final w1 = b1.width;
        final h1 = b1.height == 0 ? 0.001 : b1.height;
        final w2 = b2.width;
        final h2 = b2.height == 0 ? 0.001 : b2.height;
        final ar1 = w1 / h1;
        final ar2 = w2 / h2;

        if (ar1 > 1.0 && ar2 > 1.0) {
          final gap = math.max(b1.top - b2.bottom, b2.top - b1.bottom);
          if (gap > 0 && gap < 25.0) {
            return '=';
          }
        }
      }
    }

    return '?';
  }
}
