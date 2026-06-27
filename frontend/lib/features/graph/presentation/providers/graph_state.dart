import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/graph_data.dart';

part 'graph_state.freezed.dart';
part 'graph_state.g.dart';

/// Immutable state managing active graph data keyed by expression ID.
@freezed
class GraphState with _$GraphState {
  const factory GraphState({
    /// Active graphs keyed by expression ID.
    @Default(<String, GraphData>{}) Map<String, GraphData> graphs,

    /// Whether a graph generation is currently pending.
    @Default(false) bool isPending,

    /// Error message if the last operation failed.
    String? error,
  }) = _GraphState;

  /// Creates a [GraphState] from a JSON map.
  factory GraphState.fromJson(Map<String, dynamic> json) =>
      _$GraphStateFromJson(json);
}
