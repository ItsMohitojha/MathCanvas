import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mathcanvas/app/theme/app_theme.dart';
import 'package:mathcanvas/features/settings/presentation/widgets/settings_bottom_sheet.dart';
import '../providers/notebook_state_provider.dart';
import '../providers/notebook_state.dart';
import '../widgets/notebook_card.dart';
import '../../domain/models/notebook.dart';

/// The main entry dashboard displaying all created notebooks in a grid.
class HomeScreen extends ConsumerStatefulWidget {
  /// Creates a [HomeScreen].
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notebookStateProvider);
    final colors = context.appColorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Filter notebooks by search query
    final filteredNotebooks = state.notebooks.where((notebook) {
      return notebook.name.toLowerCase().contains(_searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: colors.canvasBackground,
      appBar: AppBar(
        title: Text(
          'MathCanvas',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => SettingsBottomSheet.show(context),
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: colors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search & Filter header
          if (state.notebooks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search notebooks...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => _searchController.clear(),
                        )
                      : null,
                  filled: true,
                  fillColor: colors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),

          // Main body content
          Expanded(
            child: _buildBody(context, state, filteredNotebooks),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateNotebookDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('New Notebook'),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 4,
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    NotebookState state,
    List<Notebook> filteredNotebooks,
  ) {
    final colors = context.appColorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (state.isPending && state.notebooks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.notebooks.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.draw_outlined,
                  size: 64,
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No Notebooks Yet',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create a new notebook to start drawing, solving, and graphing mathematical equations offline.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (filteredNotebooks.isEmpty) {
      return const Center(
        child: Text('No matching notebooks found'),
      );
    }

    // Modern Responsive Grid
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 600 ? 3 : 2;

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.2,
      ),
      itemCount: filteredNotebooks.length,
      itemBuilder: (context, index) {
        final notebook = filteredNotebooks[index];
        return NotebookCard(
          notebook: notebook,
          onTap: () {
            ref.read(notebookStateProvider.notifier).selectNotebook(notebook.id);
            context.pushNamed(
              'canvas',
              pathParameters: {'id': notebook.id},
            );
          },
          onLongPress: () => _showNotebookActionsBottomSheet(context, notebook),
        );
      },
    );
  }

  void _showCreateNotebookDialog(BuildContext context) {
    final controller = TextEditingController();
    final colors = context.appColorScheme;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Notebook'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter notebook name...',
            labelText: 'Notebook Name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
            ),
            onPressed: () async {
              final name = controller.text.trim();
              Navigator.of(ctx).pop();
              final newNotebook = await ref
                  .read(notebookStateProvider.notifier)
                  .createNotebook(name);
              if (newNotebook != null && context.mounted) {
                context.pushNamed(
                  'canvas',
                  pathParameters: {'id': newNotebook.id},
                );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showNotebookActionsBottomSheet(BuildContext context, Notebook notebook) {
    final colors = context.appColorScheme;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              notebook.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Rename'),
              onTap: () {
                Navigator.of(context).pop();
                _showRenameNotebookDialog(context, notebook);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.of(context).pop();
                _showDeleteConfirmationDialog(context, notebook);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameNotebookDialog(BuildContext context, Notebook notebook) {
    final controller = TextEditingController(text: notebook.name);
    final colors = context.appColorScheme;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Notebook'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter new name...',
            labelText: 'New Name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
            ),
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                ref
                    .read(notebookStateProvider.notifier)
                    .renameNotebook(notebook.id, newName);
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Notebook notebook) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Notebook?'),
        content: Text(
          'Are you sure you want to delete "${notebook.name}"? '
          'This action cannot be undone and will delete all drawings, equations, and graphs.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              ref
                  .read(notebookStateProvider.notifier)
                  .deleteNotebook(notebook.id);
              Navigator.of(ctx).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
