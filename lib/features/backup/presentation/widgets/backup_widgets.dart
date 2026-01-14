import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroic_lsfg_applier/core/theme/steam_deck_constants.dart';
import 'package:heroic_lsfg_applier/features/backup/domain/entities/backup_entity.dart';
import 'package:heroic_lsfg_applier/features/backup/presentation/cubit/backup_cubit.dart';
import 'package:intl/intl.dart';

/// Card widget for displaying a single backup - optimized for Steam Deck
class BackupCard extends StatefulWidget {
  final Backup backup;
  final VoidCallback onRestore;
  final VoidCallback onDelete;
  
  const BackupCard({
    super.key,
    required this.backup,
    required this.onRestore,
    required this.onDelete,
  });

  @override
  State<BackupCard> createState() => _BackupCardState();
}

class _BackupCardState extends State<BackupCard> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd().add_jm();
    final colorScheme = Theme.of(context).colorScheme;
    
    return Focus(
      onFocusChange: (focused) => setState(() => _isFocused = focused),
      child: Card(
        elevation: _isFocused ? 8 : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SteamDeckConstants.cardRadius),
          side: BorderSide(
            color: _isFocused ? SteamDeckConstants.focusColor : Colors.transparent,
            width: _isFocused ? SteamDeckConstants.focusBorderWidth : 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(SteamDeckConstants.cardPadding),
          child: Row(
            children: [
              Container(
                width: SteamDeckConstants.preferredTouchTarget,
                height: SteamDeckConstants.preferredTouchTarget,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.folder_zip,
                  size: 28,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: SteamDeckConstants.cardPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateFormat.format(widget.backup.createdAt),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.backup.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: SteamDeckConstants.elementGap),
              // Large touch targets for actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilledButton.tonal(
                    onPressed: widget.onRestore,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(SteamDeckConstants.minTouchTarget, SteamDeckConstants.minTouchTarget),
                    ),
                    child: const Icon(Icons.restore),
                  ),
                  const SizedBox(width: 8),
                  IconButton.outlined(
                    onPressed: widget.onDelete,
                    icon: Icon(Icons.delete_outline, color: colorScheme.error),
                    style: IconButton.styleFrom(
                      minimumSize: const Size(SteamDeckConstants.minTouchTarget, SteamDeckConstants.minTouchTarget),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Empty state widget for backups
class BackupsEmptyState extends StatelessWidget {
  const BackupsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SteamDeckConstants.spaciousPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: 80,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: SteamDeckConstants.cardPadding),
            Text(
              'No backups yet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first backup above',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error state widget for backups
class BackupsErrorState extends StatelessWidget {
  final String message;
  
  const BackupsErrorState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SteamDeckConstants.spaciousPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: SteamDeckConstants.cardPadding),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: SteamDeckConstants.spaciousPadding),
            FilledButton.icon(
              onPressed: () => context.read<BackupCubit>().loadBackups(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: SteamDeckConstants.primaryButtonStyle,
            ),
          ],
        ),
      ),
    );
  }
}

/// Loading state widget for backups
class BackupsLoadingState extends StatelessWidget {
  final String? message;
  
  const BackupsLoadingState({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          if (message != null) ...[
            const SizedBox(height: SteamDeckConstants.cardPadding),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ],
      ),
    );
  }
}
