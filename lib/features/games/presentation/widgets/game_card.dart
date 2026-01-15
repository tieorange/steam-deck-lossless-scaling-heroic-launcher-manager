import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroic_lsfg_applier/core/theme/steam_deck_constants.dart';
import 'package:heroic_lsfg_applier/features/games/domain/entities/game_entity.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/cubit/games_cubit.dart';

/// Card widget for displaying a single game - optimized for Steam Deck
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
