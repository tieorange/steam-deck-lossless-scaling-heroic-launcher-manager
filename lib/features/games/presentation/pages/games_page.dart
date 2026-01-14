import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroic_lsfg_applier/features/games/domain/entities/game_entity.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/cubit/games_cubit.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/cubit/games_state.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/widgets/game_card.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/widgets/games_action_bar.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/widgets/games_search_bar.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/widgets/games_states.dart';

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
        title: const Text('Games'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => context.read<GamesCubit>().loadGames(),
          ),
        ],
      ),
      body: Column(
        children: [
          GamesSearchBar(controller: _searchController),
          Expanded(child: _buildGamesList()),
          GamesActionBar(
            onApply: () => _showApplyConfirmation(context),
            onRemove: () => _showRemoveConfirmation(context),
          ),
        ],
      ),
    );
  }
  
  Widget _buildGamesList() {
    return BlocBuilder<GamesCubit, GamesState>(
      builder: (context, state) {
        return state.when(
          loading: () => const GamesLoadingState(),
          error: (message) => GamesErrorState(message: message),
          loaded: (games, filteredGames, searchQuery, isApplying) {
            if (isApplying) {
              return const GamesLoadingState(message: 'Applying changes...');
            }
            if (filteredGames.isEmpty) {
              return GamesEmptyState(hasSearchQuery: searchQuery.isNotEmpty);
            }
            return _buildGamesListView(filteredGames);
          },
        );
      },
    );
  }
  
  Widget _buildGamesListView(List<Game> games) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: games.length,
      itemBuilder: (context, index) => GameCard(game: games[index]),
    );
  }
  
  void _showApplyConfirmation(BuildContext context) {
    final cubit = context.read<GamesCubit>();
    final count = cubit.selectedCount;
    
    if (count == 0) return;
    
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
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await cubit.applyLsfgToSelected();
              if (context.mounted) {
                final state = cubit.state;
                if (state is GamesLoaded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('LSFG applied successfully!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Failed to apply LSFG. Please try again.'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              }
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
    
    if (count == 0) return;
    
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
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await cubit.removeLsfgFromSelected();
              if (context.mounted) {
                final state = cubit.state;
                if (state is GamesLoaded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('LSFG removed successfully!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Failed to remove LSFG. Please try again.'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              }
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
