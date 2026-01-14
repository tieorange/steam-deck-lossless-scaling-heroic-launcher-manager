import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroic_lsfg_applier/core/theme/steam_deck_constants.dart';
import 'package:heroic_lsfg_applier/features/backup/presentation/cubit/backup_cubit.dart';
import 'package:heroic_lsfg_applier/features/backup/presentation/cubit/backup_state.dart';

/// Header section with create backup button - optimized for Steam Deck
class CreateBackupSection extends StatelessWidget {
  final VoidCallback onCreateBackup;
  
  const CreateBackupSection({super.key, required this.onCreateBackup});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BackupCubit, BackupState>(
      builder: (context, state) {
        final isCreating = state is BackupLoaded && state.isCreating;
        
        return Container(
          padding: const EdgeInsets.all(SteamDeckConstants.spaciousPadding),
          child: Column(
            children: [
              Icon(
                Icons.backup,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: SteamDeckConstants.cardPadding),
              Text(
                'Create a backup before making changes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Backups include all game configuration files from Heroic Games Launcher',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SteamDeckConstants.spaciousPadding),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: isCreating ? null : onCreateBackup,
                  icon: isCreating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add),
                  label: Text(isCreating ? 'Creating...' : 'Create Backup Now'),
                  style: SteamDeckConstants.primaryButtonStyle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
