import '../models/notebook.dart';

/// Repository interface managing notebook CRUD and viewport persistence.
abstract class NotebookRepository {
  /// Fetches all notebooks from the database, sorted by updated_at DESC.
  Future<List<Notebook>> getNotebooks();

  /// Fetches a specific notebook by its ID.
  Future<Notebook?> getNotebookById(String id);

  /// Creates a new notebook with the given name.
  Future<Notebook> createNotebook(String name);

  /// Renames an existing notebook.
  Future<void> renameNotebook(String id, String name);

  /// Deletes a notebook and all associated data.
  Future<void> deleteNotebook(String id);

  /// Updates the viewport offsets and zoom level for a notebook.
  Future<void> updateViewport(String id, double x, double y, double zoom);
}
