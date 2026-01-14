import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:heroic_lsfg_applier/features/backup/domain/entities/backup_entity.dart';
import 'package:heroic_lsfg_applier/features/backup/presentation/cubit/backup_cubit.dart';
import 'package:heroic_lsfg_applier/features/backup/presentation/cubit/backup_state.dart';
import 'package:intl/intl.dart';

/// Page for managing backups
class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  @override
  void initState() {
    super.initState();
    context.read<BackupCubit>().loadBackups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Backup & Restore'),
      ),
      body: Column(
        children: [
          _buildCreateBackupSection(),
          const Divider(height: 1),
          Expanded(child: _buildBackupList()),
        ],
      ),
    );
  }
  
  Widget _buildCreateBackupSection() {
    return BlocBuilder<BackupCubit, BackupState>(
      builder: (context, state) {
        final isCreating = state is BackupLoaded && state.isCreating;
        
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.backup,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Create a backup before making changes',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Backups include all game configuration files from Heroic Games Launcher',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: isCreating ? null : () => _createBackup(context),
                icon: isCreating
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.add),
                label: Text(isCreating ? 'Creating...' : 'Create Backup Now'),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildBackupList() {
    return BlocBuilder<BackupCubit, BackupState>(
      builder: (context, state) {
        return state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) => _buildErrorState(message),
          loaded: (backups, isCreating, isRestoring) {
            if (backups.isEmpty) {
              return _buildEmptyState();
            }
            if (isRestoring) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Restoring backup...'),
                  ],
                ),
              );
            }
            return _buildBackupListView(backups);
          },
        );
      },
    );
  }
  
  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.read<BackupCubit>().loadBackups(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No backups yet',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first backup above',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBackupListView(List<Backup> backups) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Existing Backups (${backups.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: backups.length,
            itemBuilder: (context, index) => _BackupCard(
              backup: backups[index],
              onRestore: () => _restoreBackup(context, backups[index]),
              onDelete: () => _deleteBackup(context, backups[index]),
            ),
          ),
        ),
      ],
    );
  }
  
  void _createBackup(BuildContext context) async {
    final success = await context.read<BackupCubit>().createBackup();
    if (context.mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup created successfully!')),
      );
    }
  }
  
  void _restoreBackup(BuildContext context, Backup backup) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Restore Backup?'),
        content: Text(
          'This will replace your current game configurations with the backup from '
          '${DateFormat.yMMMd().add_jm().format(backup.createdAt)}.\n\n'
          'This action cannot be undone. Consider creating a new backup first.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final success = await context.read<BackupCubit>().restoreBackup(backup);
              if (context.mounted && success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Backup restored successfully!')),
                );
              }
            },
            child: const Text('Restore'),
          ),
        ],
      ),
    );
  }
  
  void _deleteBackup(BuildContext context, Backup backup) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Backup?'),
        content: Text(
          'Are you sure you want to delete the backup from '
          '${DateFormat.yMMMd().add_jm().format(backup.createdAt)}?\n\n'
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final success = await context.read<BackupCubit>().deleteBackup(backup);
              if (context.mounted && success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Backup deleted.')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// Card widget for displaying a single backup
class _BackupCard extends StatelessWidget {
  final Backup backup;
  final VoidCallback onRestore;
  final VoidCallback onDelete;
  
  const _BackupCard({
    required this.backup,
    required this.onRestore,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd().add_jm();
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.folder_zip,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateFormat.format(backup.createdAt),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    backup.name,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.restore),
              tooltip: 'Restore',
              onPressed: onRestore,
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              tooltip: 'Delete',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
