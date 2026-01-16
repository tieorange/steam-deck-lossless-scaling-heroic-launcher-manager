import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroic_lsfg_applier/core/theme/steam_deck_constants.dart';
import 'package:heroic_lsfg_applier/features/games/domain/entities/game_entity.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/cubit/games_cubit.dart';

/// Card widget for displaying a single game - optimized for Steam Deck.
/// 
/// Features:
/// - Large touch targets for Steam Deck touchscreen/trackpad
/// - Focus handling for gamepad navigation
/// - Tap to select, long-press for context menu
class GameCard extends StatefulWidget {
  final Game game;
  
  const GameCard({super.key, required this.game});

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Focus(
      onFocusChange: (focused) => setState(() => _isFocused = focused),
      child: Card(
        elevation: _isFocused ? 8 : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SteamDeckConstants.cardRadius),
          side: BorderSide(
            color: _isFocused 
              ? SteamDeckConstants.focusColor 
              : widget.game.isSelected 
                ? colorScheme.primary.withValues(alpha: 0.5)
                : Colors.transparent,
            width: _isFocused ? SteamDeckConstants.focusBorderWidth : 1.0,
          ),
        ),
        color: widget.game.isSelected 
          ? colorScheme.primaryContainer.withValues(alpha: 0.3)
          : null,
        child: InkWell(
          borderRadius: BorderRadius.circular(SteamDeckConstants.cardRadius),
          onTap: () => context.read<GamesCubit>().toggleGameSelection(widget.game.id),
          onLongPress: () => _showContextMenu(context),
          child: Padding(
            padding: const EdgeInsets.all(SteamDeckConstants.cardPadding),
            child: Row(
              children: [
                // Larger checkbox with increased touch target
                SizedBox(
                  width: SteamDeckConstants.minTouchTarget,
                  height: SteamDeckConstants.minTouchTarget,
                  child: Checkbox(
                    value: widget.game.isSelected,
                    onChanged: (_) => context.read<GamesCubit>().toggleGameSelection(widget.game.id),
                  ),
                ),
                const SizedBox(width: SteamDeckConstants.elementGap),
                _buildIcon(),
                const SizedBox(width: SteamDeckConstants.cardPadding),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.game.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.game.internalId,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.outline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: SteamDeckConstants.elementGap),
                LsfgBadge(hasLsfgEnabled: widget.game.hasLsfgEnabled),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildIcon() {
    if (widget.game.iconPath != null && File(widget.game.iconPath!).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          File(widget.game.iconPath!),
          width: SteamDeckConstants.cardIconSize,
          height: SteamDeckConstants.cardIconSize,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const GamePlaceholderIcon(),
        ),
      );
    }
    return const GamePlaceholderIcon();
  }

  void _showContextMenu(BuildContext context) {
    final cubit = context.read<GamesCubit>();
    final game = widget.game;
    
    showModalBottomSheet(
      context: context,
      builder: (btmContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with game name
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                game.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(height: 1),
            
            // Apply LSFG option
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Apply LSFG'),
              subtitle: const Text('Enable Frame Generation'),
              enabled: !game.hasLsfgEnabled,
              onTap: () => _applyLsfg(btmContext, cubit, game),
            ),
            
            // Remove LSFG option
            ListTile(
              leading: const Icon(Icons.remove_circle_outline),
              title: const Text('Remove LSFG'),
              subtitle: const Text('Disable Frame Generation'),
              enabled: game.hasLsfgEnabled,
              onTap: () => _removeLsfg(btmContext, cubit, game),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _applyLsfg(BuildContext btmContext, GamesCubit cubit, Game game) async {
    Navigator.pop(btmContext);
    
    // Capture context-dependent values before async gaps
    final messenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Apply LSFG?'),
        content: Text(
          'Enable Lossless Scaling frame generation for "${game.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      final success = await cubit.applyLsfgToGame(game.id);
      messenger.showSnackBar(
        SnackBar(
          content: Text(success 
            ? 'LSFG applied to ${game.title}' 
            : 'Failed to apply LSFG'),
          backgroundColor: success ? null : theme.colorScheme.error,
        ),
      );
    }
  }
  
  Future<void> _removeLsfg(BuildContext btmContext, GamesCubit cubit, Game game) async {
    Navigator.pop(btmContext);
    
    // Capture context-dependent values before async gaps
    final messenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove LSFG?'),
        content: Text(
          'Disable Lossless Scaling frame generation for "${game.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      final success = await cubit.removeLsfgFromGame(game.id);
      messenger.showSnackBar(
        SnackBar(
          content: Text(success 
            ? 'LSFG removed from ${game.title}' 
            : 'Failed to remove LSFG'),
          backgroundColor: success ? null : theme.colorScheme.error,
        ),
      );
    }
  }
}

/// Placeholder icon for games without an icon - larger size
class GamePlaceholderIcon extends StatelessWidget {
  const GamePlaceholderIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SteamDeckConstants.cardIconSize,
      height: SteamDeckConstants.cardIconSize,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.games,
        size: 32,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}

/// Badge showing LSFG enabled/disabled status - larger for touch
class LsfgBadge extends StatelessWidget {
  final bool hasLsfgEnabled;
  
  const LsfgBadge({super.key, required this.hasLsfgEnabled});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    if (hasLsfgEnabled) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              size: 20,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              'LSFG',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'Not applied',
        style: TextStyle(
          fontSize: 14,
          color: colorScheme.outline,
        ),
      ),
    );
  }
}
