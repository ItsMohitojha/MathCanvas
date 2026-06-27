import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mathcanvas/features/notebook/domain/models/notebook.dart';
import 'package:mathcanvas/features/notebook/domain/repositories/notebook_repository.dart';
import 'package:mathcanvas/features/notebook/presentation/providers/notebook_state_provider.dart';

class FakeNotebookRepository implements NotebookRepository {
  final List<Notebook> notebooks = [];

  @override
  Future<List<Notebook>> getNotebooks() async {
    return List<Notebook>.from(notebooks)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  Future<Notebook?> getNotebookById(String id) async {
    try {
      return notebooks.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Notebook> createNotebook(String name) async {
    final now = DateTime.now();
    final newNotebook = Notebook(
      id: 'id_${notebooks.length}',
      name: name.isEmpty ? 'Untitled Notebook' : name,
      createdAt: now,
      updatedAt: now,
    );
    notebooks.add(newNotebook);
    return newNotebook;
  }

  @override
  Future<void> renameNotebook(String id, String name) async {
    final index = notebooks.indexWhere((n) => n.id == id);
    if (index != -1) {
      notebooks[index] = notebooks[index].copyWith(
        name: name,
        updatedAt: DateTime.now(),
      );
    }
  }

  @override
  Future<void> deleteNotebook(String id) async {
    notebooks.removeWhere((n) => n.id == id);
  }

  @override
  Future<void> updateViewport(String id, double x, double y, double zoom) async {
    final index = notebooks.indexWhere((n) => n.id == id);
    if (index != -1) {
      notebooks[index] = notebooks[index].copyWith(
        viewportX: x,
        viewportY: y,
        zoomLevel: zoom,
        updatedAt: DateTime.now(),
      );
    }
  }
}

void main() {
  group('NotebookStateNotifier', () {
    late FakeNotebookRepository fakeRepository;
    late ProviderContainer container;

    setUp(() {
      fakeRepository = FakeNotebookRepository();
      container = ProviderContainer(
        overrides: [
          notebookRepositoryProvider.overrideWithValue(fakeRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state loads all notebooks', () async {
      final now = DateTime.now();
      fakeRepository.notebooks.addAll([
        Notebook(id: '1', name: 'N1', createdAt: now, updatedAt: now),
        Notebook(id: '2', name: 'N2', createdAt: now, updatedAt: now),
      ]);

      // Read to trigger build
      container.read(notebookStateProvider);

      // Wait for future loading
      await container.read(notebookStateProvider.notifier).loadNotebooks();

      final updatedState = container.read(notebookStateProvider);
      expect(updatedState.isPending, isFalse);
      expect(updatedState.notebooks.length, 2);
      expect(updatedState.notebooks[0].name, 'N1');
    });

    test('selectNotebook sets activeNotebook', () async {
      final now = DateTime.now();
      final notebook = Notebook(id: 'nb1', name: 'Math 101', createdAt: now, updatedAt: now);
      fakeRepository.notebooks.add(notebook);

      final notifier = container.read(notebookStateProvider.notifier);
      await notifier.loadNotebooks();
      await notifier.selectNotebook('nb1');

      final state = container.read(notebookStateProvider);
      expect(state.activeNotebook, isNotNull);
      expect(state.activeNotebook!.id, 'nb1');
    });

    test('createNotebook adds new notebook and sets it active', () async {
      final notifier = container.read(notebookStateProvider.notifier);
      await notifier.createNotebook('New Idea');

      final state = container.read(notebookStateProvider);
      expect(state.notebooks.length, 1);
      expect(state.notebooks[0].name, 'New Idea');
      expect(state.activeNotebook?.name, 'New Idea');
    });

    test('renameNotebook updates title and preserves metadata', () async {
      final notifier = container.read(notebookStateProvider.notifier);
      final created = await notifier.createNotebook('Draft');
      
      await notifier.renameNotebook(created!.id, 'Final Version');

      final state = container.read(notebookStateProvider);
      expect(state.notebooks[0].name, 'Final Version');
      expect(state.activeNotebook?.name, 'Final Version');
    });

    test('deleteNotebook removes notebook and clears active if deleted', () async {
      final notifier = container.read(notebookStateProvider.notifier);
      final created = await notifier.createNotebook('Draft');

      await notifier.deleteNotebook(created!.id);

      final state = container.read(notebookStateProvider);
      expect(state.notebooks, isEmpty);
      expect(state.activeNotebook, isNull);
    });

    test('saveViewport updates active notebook coordinates', () async {
      final notifier = container.read(notebookStateProvider.notifier);
      final created = await notifier.createNotebook('Coords');

      await notifier.saveViewport(created!.id, 20.0, -10.0, 1.25);

      final state = container.read(notebookStateProvider);
      expect(state.activeNotebook!.viewportX, 20.0);
      expect(state.activeNotebook!.viewportY, -10.0);
      expect(state.activeNotebook!.zoomLevel, 1.25);
    });
  });
}
