import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroic_lsfg_applier/core/theme/steam_deck_constants.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/cubit/games_cubit.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/cubit/games_state.dart';

/// Bottom action bar with selection and apply/remove buttons.
/// 
/// Optimized for Steam Deck with large touch targets.
/// Includes quick selection options and LSFG apply/remove actions.
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
        
        final cubit = context.read<GamesCubit>();
        final selectedCount = cubit.selectedCount;
        final enabledCount = state.games.where((g) => g.hasLsfgEnabled).length;
        final disabledCount = state.games.length - enabledCount;
        
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
                // Selection row with count and quick actions
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
                          '$enabledCount enabled / ${state.games.length} total',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                    // Quick selection dropdown
                    PopupMenuButton<_SelectionAction>(
                      tooltip: 'Quick Selection',
                      icon: const Icon(Icons.checklist),
                      onSelected: (action) => _handleSelectionAction(context, cubit, action),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: _SelectionAction.all,
                          child: ListTile(
                            leading: Icon(Icons.select_all),
                            title: Text('Select All'),
                            dense: true,
                          ),
                        ),
                        PopupMenuItem(
                          value: _SelectionAction.withoutLsfg,
                          enabled: disabledCount > 0,
                          child: ListTile(
                            leading: const Icon(Icons.remove_done),
                            title: const Text('Select Without LSFG'),
                            subtitle: Text('$disabledCount games'),
                            dense: true,
                          ),
                        ),
                        const PopupMenuItem(
                          value: _SelectionAction.none,
                          child: ListTile(
                            leading: Icon(Icons.deselect),
                            title: Text('Deselect All'),
                            dense: true,
                          ),
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
  
  void _handleSelectionAction(BuildContext context, GamesCubit cubit, _SelectionAction action) {
    switch (action) {
      case _SelectionAction.all:
        cubit.selectAll();
        break;
      case _SelectionAction.withoutLsfg:
        cubit.selectAllWithoutLsfg();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selected games without LSFG')),
        );
        break;
      case _SelectionAction.none:
        cubit.deselectAll();
        break;
    }
  }
}

enum _SelectionAction { all, withoutLsfg, none }
