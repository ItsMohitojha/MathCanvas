import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mathcanvas/shared/database/database_provider.dart';
import '../../domain/models/notebook.dart';
import '../../domain/repositories/notebook_repository.dart';
import '../../data/datasources/notebook_local_datasource.dart';
import '../../data/repositories/notebook_repository_impl.dart';
import 'notebook_state.dart';

/// Provider for the Notebook Local Datasource.
final notebookLocalDatasourceProvider = Provider<NotebookLocalDatasource>((ref) {
  final dbFuture = ref.watch(databaseProvider);
  return NotebookLocalDatasourceImpl(dbFuture);
});

/// Provider for the Notebook Repository.
final notebookRepositoryProvider = Provider<NotebookRepository>((ref) {
  final local = ref.watch(notebookLocalDatasourceProvider);
  return NotebookRepositoryImpl(local);
});

/// Riverpod provider managing the Notebook state.
final notebookStateProvider =
    NotifierProvider<NotebookStateNotifier, NotebookState>(
  NotebookStateNotifier.new,
);

/// Riverpod Notifier managing notebook CRUD operations.
class NotebookStateNotifier extends Notifier<NotebookState> {
  @override
  NotebookState build() {
    // Load notebooks on initialization
    Future.microtask(() => loadNotebooks());
    return const NotebookState();
  }

  /// Loads all notebooks from SQLite.
  Future<void> loadNotebooks() async {
    state = state.copyWith(isPending: true, error: null);
    try {
      final repository = ref.read(notebookRepositoryProvider);
      final notebooks = await repository.getNotebooks();
      state = state.copyWith(
        notebooks: notebooks,
        isPending: false,
      );
    } catch (e) {
      state = state.copyWith(
        isPending: false,
        error: 'Failed to load notebooks: $e',
      );
    }
  }

  /// Selects a notebook to make it active.
  Future<void> selectNotebook(String? id) async {
    if (id == null) {
      state = state.copyWith(activeNotebook: null);
      return;
    }

    final existing = state.notebooks.firstWhereOrNull((n) => n.id == id);
    if (existing != null) {
      state = state.copyWith(activeNotebook: existing);
      return;
    }

    // Fallback: fetch from repository if not in the cached list
    try {
      final repository = ref.read(notebookRepositoryProvider);
      final notebook = await repository.getNotebookById(id);
      if (notebook != null) {
        state = state.copyWith(activeNotebook: notebook);
      } else {
        state = state.copyWith(error: 'Notebook not found');
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to select notebook: $e');
    }
  }

  /// Creates a new notebook and refreshes the list.
  Future<Notebook?> createNotebook(String name) async {
    state = state.copyWith(isPending: true, error: null);
    try {
      final repository = ref.read(notebookRepositoryProvider);
      final newNotebook = await repository.createNotebook(name);
      
      final updatedList = List<Notebook>.from(state.notebooks)..insert(0, newNotebook);
      state = state.copyWith(
        notebooks: updatedList,
        activeNotebook: newNotebook,
        isPending: false,
      );
      return newNotebook;
    } catch (e) {
      state = state.copyWith(
        isPending: false,
        error: 'Failed to create notebook: $e',
      );
      return null;
    }
  }

  /// Renames an existing notebook.
  Future<void> renameNotebook(String id, String name) async {
    if (name.trim().isEmpty) return;
    
    state = state.copyWith(isPending: true, error: null);
    try {
      final repository = ref.read(notebookRepositoryProvider);
      await repository.renameNotebook(id, name);

      // Re-load list from DB to ensure accurate state and sorting
      final notebooks = await repository.getNotebooks();
      Notebook? updatedActive = state.activeNotebook;
      if (updatedActive != null && updatedActive.id == id) {
        updatedActive = updatedActive.copyWith(
          name: name.trim(),
          updatedAt: DateTime.now(),
        );
      }

      state = state.copyWith(
        notebooks: notebooks,
        activeNotebook: updatedActive,
        isPending: false,
      );
    } catch (e) {
      state = state.copyWith(
        isPending: false,
        error: 'Failed to rename notebook: $e',
      );
    }
  }

  /// Deletes a notebook and clears it if it is the active one.
  Future<void> deleteNotebook(String id) async {
    state = state.copyWith(isPending: true, error: null);
    try {
      final repository = ref.read(notebookRepositoryProvider);
      await repository.deleteNotebook(id);

      final updatedList = state.notebooks.where((n) => n.id != id).toList();
      Notebook? updatedActive = state.activeNotebook;
      if (updatedActive != null && updatedActive.id == id) {
        updatedActive = null;
      }

      state = state.copyWith(
        notebooks: updatedList,
        activeNotebook: updatedActive,
        isPending: false,
      );
    } catch (e) {
      state = state.copyWith(
        isPending: false,
        error: 'Failed to delete notebook: $e',
      );
    }
  }

  /// Updates viewport state (pan, zoom) in local DB and cached list.
  Future<void> saveViewport(String id, double x, double y, double zoom) async {
    try {
      final repository = ref.read(notebookRepositoryProvider);
      await repository.updateViewport(id, x, y, zoom);

      // Optimistically update active notebook state and the notebook list
      final now = DateTime.now();
      
      final updatedList = state.notebooks.map((n) {
        if (n.id == id) {
          return n.copyWith(
            viewportX: x,
            viewportY: y,
            zoomLevel: zoom,
            updatedAt: now,
          );
        }
        return n;
      }).toList();

      // Maintain sorting by updatedAt (descending)
      updatedList.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      Notebook? updatedActive = state.activeNotebook;
      if (updatedActive != null && updatedActive.id == id) {
        updatedActive = updatedActive.copyWith(
          viewportX: x,
          viewportY: y,
          zoomLevel: zoom,
          updatedAt: now,
        );
      }

      state = state.copyWith(
        notebooks: updatedList,
        activeNotebook: updatedActive,
      );
    } catch (e) {
      // Log errors silently to avoid disrupting user experience
      state = state.copyWith(error: 'Failed to save viewport position: $e');
    }
  }
}
