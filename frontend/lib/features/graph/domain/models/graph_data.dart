import 'package:freezed_annotation/freezed_annotation.dart';

part 'graph_data.freezed.dart';
part 'graph_data.g.dart';

/// Immutable domain model representing graph coordinate data for a function expression.
@freezed
class GraphData with _$GraphData {
  const factory GraphData({
    required String id,
    required String expressionId,
    @Default('x') String variable,
    @Default(-10.0) double xRangeMin,
    @Default(10.0) double xRangeMax,
    @Default(500) int numPoints,
    required List<double> xValues,
    required List<double?> yValues,
    required String title,
    @Default('#6366f1') String color,
    required DateTime generatedAt,
  }) = _GraphData;

  const GraphData._();

  /// Creates a [GraphData] from a JSON map.
  factory GraphData.fromJson(Map<String, dynamic> json) =>
      _$GraphDataFromJson(json);

  /// Computed minimum y-value from non-null data points.
  double? get yMin {
    final validY = yValues.whereType<double>();
    if (validY.isEmpty) return null;
    return validY.reduce((a, b) => a < b ? a : b);
  }

  /// Computed maximum y-value from non-null data points.
  double? get yMax {
    final validY = yValues.whereType<double>();
    if (validY.isEmpty) return null;
    return validY.reduce((a, b) => a > b ? a : b);
  }

  /// Whether the graph has any valid data points.
  bool get hasData => yValues.any((y) => y != null);
}
