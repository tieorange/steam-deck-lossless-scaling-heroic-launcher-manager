import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:heroic_lsfg_applier/core/router/app_router.dart';
import 'package:heroic_lsfg_applier/features/games/domain/entities/game_entity.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/cubit/games_cubit.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/cubit/games_state.dart';

/// Main page showing list of Heroic games
class GamesPage extends StatefulWidget {
  const GamesPage({super.key});

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  final _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    context.read<GamesCubit>().loadGames();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heroic LSFG Applier'),
        actions: [
          IconButton(
            icon: const Icon(Icons.backup),
            tooltip: 'Backup & Restore',
            onPressed: () => context.push(AppRouter.backupRoute),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => context.read<GamesCubit>().loadGames(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildGamesList()),
          _buildActionBar(),
        ],
      ),
    );
  }
  
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search games...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  context.read<GamesCubit>().search('');
                },
              )
            : null,
        ),
        onChanged: (value) => context.read<GamesCubit>().search(value),
      ),
    );
  }
  
  Widget _buildGamesList() {
    return BlocBuilder<GamesCubit, GamesState>(
      builder: (context, state) {
        return state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) => _buildErrorState(message),
          loaded: (games, filteredGames, searchQuery, isApplying) {
            if (filteredGames.isEmpty) {
              return _buildEmptyState(searchQuery.isNotEmpty);
            }
            return _buildGamesListView(filteredGames, isApplying);
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
              onPressed: () => context.read<GamesCubit>().loadGames(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmptyState(bool hasSearchQuery) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasSearchQuery ? Icons.search_off : Icons.games_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            hasSearchQuery
              ? 'No games match your search'
              : 'No games found',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
  
  Widget _buildGamesListView(List<Game> games, bool isApplying) {
    if (isApplying) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Applying changes...'),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: games.length,
      itemBuilder: (context, index) => _GameCard(game: games[index]),
    );
  }
  
  Widget _buildActionBar() {
    return BlocBuilder<GamesCubit, GamesState>(
      builder: (context, state) {
        if (state is! GamesLoaded) return const SizedBox.shrink();
        
        final selectedCount = context.read<GamesCubit>().selectedCount;
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                
                if (isWide) {
                  return Row(
                    children: [
                      Text(
                        '$selectedCount selected',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      _buildActionButtons(selectedCount),
                    ],
                  );
                }
                
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: selectedCount > 0
                              ? () => _showApplyConfirmation(context)
                              : null,
                            icon: const Icon(Icons.add_circle_outline),
                            label: const Text('Apply LSFG'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: selectedCount > 0
                              ? () => _showRemoveConfirmation(context)
                              : null,
                            icon: const Icon(Icons.remove_circle_outline),
                            label: const Text('Remove LSFG'),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildActionButtons(int selectedCount) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
        const SizedBox(width: 16),
        FilledButton.icon(
          onPressed: selectedCount > 0
            ? () => _showApplyConfirmation(context)
            : null,
          icon: const Icon(Icons.add_circle_outline),
          label: const Text('Apply LSFG'),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: selectedCount > 0
            ? () => _showRemoveConfirmation(context)
            : null,
          icon: const Icon(Icons.remove_circle_outline),
          label: const Text('Remove LSFG'),
        ),
      ],
    );
  }
  
  void _showApplyConfirmation(BuildContext context) {
    final cubit = context.read<GamesCubit>();
    final count = cubit.selectedCount;
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Apply LSFG?'),
        content: Text(
          'This will enable Lossless Scaling frame generation for $count selected game(s). '
          'Make sure to create a backup first!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              cubit.applyLsfgToSelected().then((_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('LSFG applied successfully!')),
                  );
                }
              });
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
  
  void _showRemoveConfirmation(BuildContext context) {
    final cubit = context.read<GamesCubit>();
    final count = cubit.selectedCount;
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove LSFG?'),
        content: Text(
          'This will disable Lossless Scaling frame generation for $count selected game(s).',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              cubit.removeLsfgFromSelected().then((_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('LSFG removed successfully!')),
                  );
                }
              });
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

/// Card widget for displaying a single game
class _GameCard extends StatelessWidget {
  final Game game;
  
  const _GameCard({required this.game});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.read<GamesCubit>().toggleGameSelection(game.appName),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Checkbox(
                value: game.isSelected,
                onChanged: (_) => context.read<GamesCubit>().toggleGameSelection(game.appName),
              ),
              const SizedBox(width: 8),
              _buildIcon(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      game.appName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildLsfgBadge(context),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildIcon() {
    if (game.iconPath != null && File(game.iconPath!).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(game.iconPath!),
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholderIcon(),
        ),
      );
    }
    return _buildPlaceholderIcon();
  }
  
  Widget _buildPlaceholderIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.games,
        color: Colors.white54,
      ),
    );
  }
  
  Widget _buildLsfgBadge(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    if (game.hasLsfgEnabled) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              size: 16,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Text(
              'LSFG',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Not applied',
        style: TextStyle(
          fontSize: 12,
          color: colorScheme.outline,
        ),
      ),
    );
  }
}
