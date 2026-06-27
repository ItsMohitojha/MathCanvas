import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/notebook.dart';

part 'notebook_state.freezed.dart';
part 'notebook_state.g.dart';

/// Immutable state for notebook management.
@freezed
class NotebookState with _$NotebookState {
  /// Creates a [NotebookState].
  const factory NotebookState({
    /// List of all notebooks in the system.
    @Default(<Notebook>[]) List<Notebook> notebooks,

    /// Currently active/selected notebook, if any.
    Notebook? activeNotebook,

    /// Loading state indicator.
    @Default(false) bool isPending,

    /// Error message from the last operation, if any.
    String? error,
  }) = _NotebookState;

  /// Creates a [NotebookState] from a JSON map.
  factory NotebookState.fromJson(Map<String, dynamic> json) =>
      _$NotebookStateFromJson(json);
}
