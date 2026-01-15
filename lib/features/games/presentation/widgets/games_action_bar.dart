import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroic_lsfg_applier/core/theme/steam_deck_constants.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/cubit/games_cubit.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/cubit/games_state.dart';

/// Bottom action bar with selection and apply/remove buttons
/// Optimized for Steam Deck with large touch targets
class GamesActionBar extends StatelessWidget {
  final VoidCallback onApply;
  final VoidCallback onRemove;
  
  const GamesActionBar({
    super.key,
    required this.onApply,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamesCubit, GamesState>(
      builder: (context, state) {
        if (state is! GamesLoaded) return const SizedBox.shrink();
        
        final selectedCount = context.read<GamesCubit>().selectedCount;
        
        return Container(
          padding: const EdgeInsets.all(SteamDeckConstants.cardPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Selection row with count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$selectedCount selected',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${state.games.where((g) => g.hasLsfgEnabled).length} enabled / ${state.games.length} total',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => context.read<GamesCubit>().selectAll(),
                          child: const Text('Select All'),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () => context.read<GamesCubit>().deselectAll(),
                          child: const Text('Deselect All'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: SteamDeckConstants.elementGap),
                // Action buttons - full width for easy touch
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: selectedCount > 0 ? onApply : null,
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text('Apply LSFG'),
                        style: SteamDeckConstants.primaryButtonStyle,
                      ),
                    ),
                    const SizedBox(width: SteamDeckConstants.elementGap),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: selectedCount > 0 ? onRemove : null,
                        icon: const Icon(Icons.remove_circle_outline),
                        label: const Text('Remove LSFG'),
                        style: SteamDeckConstants.outlinedButtonStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
