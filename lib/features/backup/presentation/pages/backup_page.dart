import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroic_lsfg_applier/features/backup/domain/entities/backup_entity.dart';
import 'package:heroic_lsfg_applier/features/backup/presentation/cubit/backup_cubit.dart';
import 'package:heroic_lsfg_applier/features/backup/presentation/cubit/backup_state.dart';
import 'package:heroic_lsfg_applier/features/backup/presentation/widgets/backup_widgets.dart';
import 'package:heroic_lsfg_applier/features/backup/presentation/widgets/create_backup_section.dart';
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
        title: const Text('Backup & Restore'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => context.read<BackupCubit>().loadBackups(),
          ),
        ],
      ),
      body: Column(
        children: [
          CreateBackupSection(onCreateBackup: () => _createBackup(context)),
          const Divider(height: 1),
          Expanded(child: _buildBackupList()),
        ],
      ),
    );
  }
  
  Widget _buildBackupList() {
    return BlocBuilder<BackupCubit, BackupState>(
      builder: (context, state) {
        return state.when(
          loading: () => const BackupsLoadingState(),
          error: (message) => BackupsErrorState(message: message),
          loaded: (backups, isCreating, isRestoring) {
            if (isRestoring) {
              return const BackupsLoadingState(message: 'Restoring backup...');
            }
            if (backups.isEmpty) {
              return const BackupsEmptyState();
            }
            return _buildBackupListView(backups);
          },
        );
      },
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
            itemBuilder: (context, index) => BackupCard(
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
