import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroic_lsfg_applier/core/theme/steam_deck_constants.dart';
import 'package:heroic_lsfg_applier/features/games/domain/entities/game_entity.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/cubit/games_cubit.dart';

/// Empty state widget when no games are found.
/// 
/// Shows context-specific messages based on game source and search state.
class GamesEmptyState extends StatelessWidget {
  final bool hasSearchQuery;
  final GameType? gameType;
  
  const GamesEmptyState({
    super.key, 
    required this.hasSearchQuery,
    this.gameType,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SteamDeckConstants.spaciousPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasSearchQuery ? Icons.search_off : Icons.games_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: SteamDeckConstants.cardPadding),
            Text(
              hasSearchQuery
                ? 'No games match your search'
                : 'No games found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (!hasSearchQuery) ...[
              const SizedBox(height: 8),
              Text(
                _getHelpText(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  String _getHelpText() {
    return switch (gameType) {
      GameType.heroic => 'Make sure Heroic Games Launcher is installed and has games configured.',
      GameType.ogi => 'Install games via OpenGameInstaller and add them to Steam.',
      GameType.lutris => 'Make sure Lutris is installed and has games configured.',
      null => 'Install games via Heroic, OGI, or Lutris.',
    };
  }
}

/// Error state widget
class GamesErrorState extends StatelessWidget {
  final String message;
  
  const GamesErrorState({super.key, required this.message});

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
              onPressed: () => context.read<GamesCubit>().loadGames(),
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

/// Loading state widget
class GamesLoadingState extends StatelessWidget {
  final String? message;
  
  const GamesLoadingState({super.key, this.message});

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
