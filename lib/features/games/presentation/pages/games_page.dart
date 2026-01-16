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

/// Main page showing list of games from all sources.
/// 
/// Features:
/// - Tabbed interface for Heroic, OGI, and Lutris
/// - Pull-to-refresh support
/// - Search and LSFG filter
/// - Bulk apply/remove actions
class GamesPage extends StatefulWidget {
  const GamesPage({super.key});

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<GamesCubit>().loadGames();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: BlocBuilder<GamesCubit, GamesState>(
            buildWhen: (prev, curr) {
              // Rebuild tabs when game counts change
              if (prev is GamesLoaded && curr is GamesLoaded) {
                return prev.games.length != curr.games.length;
              }
              return prev.runtimeType != curr.runtimeType;
            },
            builder: (context, state) {
              final counts = context.read<GamesCubit>().getGameCounts();
              return TabBar(
                controller: _tabController,
                tabs: [
                  _buildTab('Heroic', counts[GameType.heroic] ?? 0),
                  _buildTab('OGI', counts[GameType.ogi] ?? 0),
                  _buildTab('Lutris', counts[GameType.lutris] ?? 0),
                ],
              );
            },
          ),
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
              controller: _tabController,
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
    );
  }
  
  Widget _buildTab(String label, int count) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (count > 0) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ],
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
              return GamesEmptyState(
                hasSearchQuery: searchQuery.isNotEmpty,
                gameType: type,
              );
            }
            return _buildGamesListView(gamesForType);
          },
        );
      },
    );
  }
  
  Widget _buildGamesListView(List<Game> games) {
    return RefreshIndicator(
      onRefresh: () => context.read<GamesCubit>().loadGames(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: games.length,
        itemBuilder: (context, index) => GameCard(game: games[index]),
      ),
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
          'A backup will be created automatically if enabled in settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              
              final success = await cubit.applyLsfgToSelected();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success 
                      ? 'LSFG applied successfully!' 
                      : 'Failed to apply LSFG. Please try again.'),
                    backgroundColor: success ? null : Theme.of(context).colorScheme.error,
                  ),
                );
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success 
                      ? 'LSFG removed successfully!' 
                      : 'Failed to remove LSFG. Please try again.'),
                    backgroundColor: success ? null : Theme.of(context).colorScheme.error,
                  ),
                );
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
