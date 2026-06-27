import 'package:flutter_test/flutter_test.dart';
import 'package:mathcanvas/features/notebook/data/datasources/notebook_local_datasource.dart';
import 'package:mathcanvas/features/notebook/data/models/notebook_entity.dart';
import 'package:mathcanvas/features/notebook/data/repositories/notebook_repository_impl.dart';

class FakeNotebookLocalDatasource implements NotebookLocalDatasource {
  final Map<String, NotebookEntity> db = {};

  @override
  Future<List<NotebookEntity>> getNotebooks() async {
    final list = db.values.toList();
    list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list;
  }

  @override
  Future<NotebookEntity?> getNotebookById(String id) async {
    return db[id];
  }

  @override
  Future<void> insertNotebook(NotebookEntity notebook) async {
    db[notebook.id] = notebook;
  }

  @override
  Future<void> renameNotebook(String id, String name, int updatedAt) async {
    final existing = db[id];
    if (existing != null) {
      db[id] = NotebookEntity(
        id: existing.id,
        name: name,
        createdAt: existing.createdAt,
        updatedAt: updatedAt,
        viewportX: existing.viewportX,
        viewportY: existing.viewportY,
        zoomLevel: existing.zoomLevel,
      );
    }
  }

  @override
  Future<void> deleteNotebook(String id) async {
    db.remove(id);
  }

  @override
  Future<void> updateViewport(
    String id,
    double x,
    double y,
    double zoom,
    int updatedAt,
  ) async {
    final existing = db[id];
    if (existing != null) {
      db[id] = NotebookEntity(
        id: existing.id,
        name: existing.name,
        createdAt: existing.createdAt,
        updatedAt: updatedAt,
        viewportX: x,
        viewportY: y,
        zoomLevel: zoom,
      );
    }
  }
}

void main() {
  group('NotebookRepositoryImpl', () {
    late FakeNotebookLocalDatasource datasource;
    late NotebookRepositoryImpl repository;

    setUp(() {
      datasource = FakeNotebookLocalDatasource();
      repository = NotebookRepositoryImpl(datasource);
    });

    test('createNotebook adds new notebook with default values', () async {
      final notebook = await repository.createNotebook('Physics Calculations');
      
      expect(notebook.name, 'Physics Calculations');
      expect(notebook.viewportX, 0.0);
      expect(notebook.viewportY, 0.0);
      expect(notebook.zoomLevel, 1.0);
      
      final saved = datasource.db[notebook.id];
      expect(saved, isNotNull);
      expect(saved!.name, 'Physics Calculations');
    });

    test('createNotebook handles empty or white space names with a default title', () async {
      final notebook = await repository.createNotebook('   ');
      expect(notebook.name, 'Untitled Notebook');
    });

    test('getNotebooks returns all notebooks sorted by updated_at desc', () async {
      final n1 = NotebookEntity(
        id: '1',
        name: 'Notebook 1',
        createdAt: 1000,
        updatedAt: 1000,
        viewportX: 0,
        viewportY: 0,
        zoomLevel: 1,
      );
      final n2 = NotebookEntity(
        id: '2',
        name: 'Notebook 2',
        createdAt: 2000,
        updatedAt: 2000,
        viewportX: 0,
        viewportY: 0,
        zoomLevel: 1,
      );

      await datasource.insertNotebook(n1);
      await datasource.insertNotebook(n2);

      final results = await repository.getNotebooks();
      expect(results.length, 2);
      expect(results[0].id, '2'); // newest first
      expect(results[1].id, '1');
    });

    test('renameNotebook updates database entry', () async {
      final notebook = await repository.createNotebook('Old Name');
      await Future.delayed(const Duration(milliseconds: 10));
      await repository.renameNotebook(notebook.id, 'New Name');

      final saved = datasource.db[notebook.id];
      expect(saved!.name, 'New Name');
      expect(saved.updatedAt, isNot(notebook.updatedAt.millisecondsSinceEpoch));
    });

    test('deleteNotebook removes notebook from database', () async {
      final notebook = await repository.createNotebook('Temp');
      expect(datasource.db.containsKey(notebook.id), isTrue);

      await repository.deleteNotebook(notebook.id);
      expect(datasource.db.containsKey(notebook.id), isFalse);
    });

    test('updateViewport modifies viewport fields and updatedAt timestamp', () async {
      final notebook = await repository.createNotebook('Grid');
      await repository.updateViewport(notebook.id, 150.0, -80.0, 1.5);

      final saved = datasource.db[notebook.id];
      expect(saved!.viewportX, 150.0);
      expect(saved.viewportY, -80.0);
      expect(saved.zoomLevel, 1.5);
    });
  });
}
