import 'package:mathcanvas/core/utils/uuid_generator.dart';
import '../../domain/models/notebook.dart';
import '../../domain/repositories/notebook_repository.dart';
import '../datasources/notebook_local_datasource.dart';
import '../models/notebook_entity.dart';

/// Concrete implementation of the [NotebookRepository].
class NotebookRepositoryImpl implements NotebookRepository {
  final NotebookLocalDatasource _localDatasource;

  /// Creates a [NotebookRepositoryImpl].
  NotebookRepositoryImpl(this._localDatasource);

  @override
  Future<List<Notebook>> getNotebooks() async {
    final entities = await _localDatasource.getNotebooks();
    return entities.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Notebook?> getNotebookById(String id) async {
    final entity = await _localDatasource.getNotebookById(id);
    return entity?.toDomain();
  }

  @override
  Future<Notebook> createNotebook(String name) async {
    final now = DateTime.now();
    final notebook = Notebook(
      id: UuidGenerator.generateV4(),
      name: name.trim().isEmpty ? 'Untitled Notebook' : name.trim(),
      createdAt: now,
      updatedAt: now,
      viewportX: 0.0,
      viewportY: 0.0,
      zoomLevel: 1.0,
    );

    final entity = NotebookEntity.fromDomain(notebook);
    await _localDatasource.insertNotebook(entity);
    return notebook;
  }

  @override
  Future<void> renameNotebook(String id, String name) async {
    final updatedAt = DateTime.now().millisecondsSinceEpoch;
    await _localDatasource.renameNotebook(id, name.trim(), updatedAt);
  }

  @override
  Future<void> deleteNotebook(String id) async {
    await _localDatasource.deleteNotebook(id);
  }

  @override
  Future<void> updateViewport(
    String id,
    double x,
    double y,
    double zoom,
  ) async {
    final updatedAt = DateTime.now().millisecondsSinceEpoch;
    await _localDatasource.updateViewport(id, x, y, zoom, updatedAt);
  }
}
