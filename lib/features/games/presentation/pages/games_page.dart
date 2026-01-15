import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroic_lsfg_applier/features/games/domain/entities/game_entity.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/cubit/games_cubit.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/cubit/games_state.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/widgets/game_card.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/widgets/games_action_bar.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/widgets/games_search_bar.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/widgets/games_states.dart';
import 'package:heroic_lsfg_applier/core/logging/logger_service.dart';

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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Games'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Heroic Launcher'),
              Tab(text: 'OpenGameInstaller'),
              Tab(text: 'Lutris'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.bug_report),
              tooltip: 'Export Logs',
              onPressed: () async {
                 final messenger = ScaffoldMessenger.of(context);
                 final result = await LoggerService.instance.exportLogs();
                 messenger.showSnackBar(SnackBar(content: Text(result)));
              },
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
            GamesSearchBar(controller: _searchController),
            _buildFilterChips(context),
            Expanded(
              child: TabBarView(
                children: [
                  _buildGameTypeTab(GameType.heroic),
                  _buildGameTypeTab(GameType.ogi),
                  _buildGameTypeTab(GameType.lutris),
                ],
              ),
            ),
            GamesActionBar(
              onApply: () => _showApplyConfirmation(context),
              onRemove: () => _showRemoveConfirmation(context),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildGameTypeTab(GameType type) {
    return BlocBuilder<GamesCubit, GamesState>(
      builder: (context, state) {
        return state.when(
          loading: () => const GamesLoadingState(),
          error: (message) => GamesErrorState(message: message),
          loaded: (games, filteredGames, searchQuery, lsfgFilter, isApplying) {
            if (isApplying) {
              return const GamesLoadingState(message: 'Applying changes...');
            }
            
            final gamesForType = filteredGames.where((g) => g.type == type).toList();
            
            if (gamesForType.isEmpty) {
              return GamesEmptyState(hasSearchQuery: searchQuery.isNotEmpty);
            }
            return _buildGamesListView(gamesForType);
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
              
              // Check for OGI games
              final hasOgiSelected = cubit.state.maybeWhen(
                loaded: (games, _, __, ___, ____) => games
                    .any((g) => g.isSelected && g.type == GameType.ogi),
                orElse: () => false,
              );
              
              if (hasOgiSelected) {
                if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Applying LSFG to OpenGameInstaller games is not yet supported.'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      action: SnackBarAction(
                        label: 'Deselect OGI', 
                        textColor: Colors.white,
                        onPressed: () {
                           // Logic to deselect OGI could be added to cubit, 
                           // but for now user has to do it manually or we apply to others.
                        }
                      ),
                    ),
                  );
                }
                return;
              }

              final success = await cubit.applyLsfgToSelected();
              if (context.mounted) {
                if (success) {
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
              final success = await cubit.removeLsfgFromSelected();
              if (context.mounted) {
                if (success) {
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
  Widget _buildFilterChips(BuildContext context) {
    return BlocBuilder<GamesCubit, GamesState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (games, filtered, query, filter, isApplying) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: filter == LsfgFilter.all,
                    onSelected: (selected) {
                      if (selected) context.read<GamesCubit>().filterByLsfg(LsfgFilter.all);
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'LSFG Enabled',
                    isSelected: filter == LsfgFilter.enabled,
                    onSelected: (selected) {
                      if (selected) context.read<GamesCubit>().filterByLsfg(LsfgFilter.enabled);
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'LSFG Disabled',
                    isSelected: filter == LsfgFilter.disabled,
                    onSelected: (selected) {
                      if (selected) context.read<GamesCubit>().filterByLsfg(LsfgFilter.disabled);
                    },
                  ),
                ],
              ),
            );
          },
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      showCheckmark: false,
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: isSelected 
          ? Theme.of(context).colorScheme.primary 
          : Theme.of(context).colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
