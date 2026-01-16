import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroic_lsfg_applier/core/logging/logger_service.dart';
import 'package:heroic_lsfg_applier/features/games/domain/entities/game_entity.dart';
import 'package:heroic_lsfg_applier/features/games/domain/repositories/game_repository.dart';
import 'package:heroic_lsfg_applier/features/games/domain/usecases/apply_lsfg_usecase.dart';
import 'package:heroic_lsfg_applier/features/games/domain/usecases/remove_lsfg_usecase.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/cubit/games_state.dart';

/// Cubit for managing games list state and selection.
/// 
/// Handles:
/// - Loading games from all sources
/// - Filtering and searching
/// - Selection management
/// - LSFG apply/remove operations via use cases
class GamesCubit extends Cubit<GamesState> {
  final GameRepository _gameRepository;
  final ApplyLsfgUseCase _applyLsfgUseCase;
  final RemoveLsfgUseCase _removeLsfgUseCase;
  
  GamesCubit(
    this._gameRepository,
    this._applyLsfgUseCase,
    this._removeLsfgUseCase,
  ) : super(const GamesState.loading());
  
  // ============ Loading ============
  
  /// Load all games from all sources (Heroic, OGI, Lutris)
  Future<void> loadGames() async {
    emit(const GamesState.loading());
    
    final result = await _gameRepository.getGames();
    
    result.fold(
      (failure) => emit(GamesState.error(message: failure.message)),
      (games) => emit(GamesState.loaded(
        games: games,
        filteredGames: games,
      )),
    );
  }
  
  // ============ Filtering ============
  
  /// Filter games by search query
  void search(String query) {
    final currentState = state;
    if (currentState is GamesLoaded) {
      _applyFilters(currentState.games, query, currentState.lsfgFilter);
    }
  }

  /// Filter games by LSFG status
  void filterByLsfg(LsfgFilter filter) {
    final currentState = state;
    if (currentState is GamesLoaded) {
      _applyFilters(currentState.games, currentState.searchQuery, filter);
    }
  }

  void _applyFilters(List<Game> games, String query, LsfgFilter filter) {
    final filtered = games.where((game) {
      // Search filter
      final matchesSearch = query.isEmpty ||
          game.title.toLowerCase().contains(query.toLowerCase()) ||
          game.internalId.toLowerCase().contains(query.toLowerCase());
      
      // LSFG status filter
      final matchesLsfg = switch (filter) {
        LsfgFilter.all => true,
        LsfgFilter.enabled => game.hasLsfgEnabled,
        LsfgFilter.disabled => !game.hasLsfgEnabled,
      };
      
      return matchesSearch && matchesLsfg;
    }).toList();

    final currentState = state;
    if (currentState is GamesLoaded) {
      emit(currentState.copyWith(
        searchQuery: query,
        lsfgFilter: filter,
        filteredGames: filtered,
      ));
    }
  }
  
  // ============ Selection ============
  
  /// Toggle selection of a single game
  void toggleGameSelection(String id) {
    final currentState = state;
    if (currentState is GamesLoaded) {
      final updatedGames = currentState.games.map((game) {
        if (game.id == id) {
          return game.copyWith(isSelected: !game.isSelected);
        }
        return game;
      }).toList();
      
      final updatedFiltered = currentState.filteredGames.map((game) {
        if (game.id == id) {
          return game.copyWith(isSelected: !game.isSelected);
        }
        return game;
      }).toList();
      
      emit(currentState.copyWith(
        games: updatedGames,
        filteredGames: updatedFiltered,
      ));
    }
  }
  
  /// Select all visible games
  void selectAll() {
    final currentState = state;
    if (currentState is GamesLoaded) {
      final visibleIds = currentState.filteredGames.map((g) => g.id).toSet();
      
      final updatedGames = currentState.games.map((game) {
        if (visibleIds.contains(game.id)) {
          return game.copyWith(isSelected: true);
        }
        return game;
      }).toList();
      
      final updatedFiltered = currentState.filteredGames.map((game) {
        return game.copyWith(isSelected: true);
      }).toList();
      
      emit(currentState.copyWith(
        games: updatedGames,
        filteredGames: updatedFiltered,
      ));
    }
  }
  
  /// Select all visible games that don't have LSFG enabled
  void selectAllWithoutLsfg() {
    final currentState = state;
    if (currentState is GamesLoaded) {
      final visibleIds = currentState.filteredGames
          .where((g) => !g.hasLsfgEnabled)
          .map((g) => g.id)
          .toSet();
      
      final updatedGames = currentState.games.map((game) {
        if (visibleIds.contains(game.id)) {
          return game.copyWith(isSelected: true);
        }
        return game.copyWith(isSelected: false);
      }).toList();
      
      final updatedFiltered = currentState.filteredGames.map((game) {
        return game.copyWith(isSelected: !game.hasLsfgEnabled);
      }).toList();
      
      emit(currentState.copyWith(
        games: updatedGames,
        filteredGames: updatedFiltered,
      ));
    }
  }
  
  /// Deselect all games
  void deselectAll() {
    final currentState = state;
    if (currentState is GamesLoaded) {
      final updatedGames = currentState.games.map((game) {
        return game.copyWith(isSelected: false);
      }).toList();
      
      final updatedFiltered = currentState.filteredGames.map((game) {
        return game.copyWith(isSelected: false);
      }).toList();
      
      emit(currentState.copyWith(
        games: updatedGames,
        filteredGames: updatedFiltered,
      ));
    }
  }
  
  /// Get count of selected games
  int get selectedCount {
    final currentState = state;
    if (currentState is GamesLoaded) {
      return currentState.games.where((g) => g.isSelected).length;
    }
    return 0;
  }
  
  /// Get count of games by type
  Map<GameType, int> getGameCounts() {
    final currentState = state;
    if (currentState is GamesLoaded) {
      return {
        GameType.heroic: currentState.games.where((g) => g.type == GameType.heroic).length,
        GameType.ogi: currentState.games.where((g) => g.type == GameType.ogi).length,
        GameType.lutris: currentState.games.where((g) => g.type == GameType.lutris).length,
      };
    }
    return {GameType.heroic: 0, GameType.ogi: 0, GameType.lutris: 0};
  }
  
  // ============ LSFG Operations ============
  
  /// Apply LSFG to selected games.
  /// Returns true if successful.
  Future<bool> applyLsfgToSelected() async {
    final currentState = state;
    if (currentState is GamesLoaded) {
      final selectedIds = currentState.games
          .where((g) => g.isSelected)
          .map((g) => g.id)
          .toList();
      
      if (selectedIds.isEmpty) {
        LoggerService.instance.log('[GamesCubit] No games selected');
        return false;
      }
      
      emit(currentState.copyWith(isApplying: true));
      
      final result = await _applyLsfgUseCase(selectedIds);
      
      return result.fold(
        (failure) {
          emit(GamesState.error(message: failure.message));
          return false;
        },
        (_) {
          loadGames(); // Reload to reflect changes
          return true;
        },
      );
    }
    return false;
  }
  
  /// Remove LSFG from selected games.
  /// Returns true if successful.
  Future<bool> removeLsfgFromSelected() async {
    final currentState = state;
    if (currentState is GamesLoaded) {
      final selectedIds = currentState.games
          .where((g) => g.isSelected)
          .map((g) => g.id)
          .toList();
      
      if (selectedIds.isEmpty) {
        LoggerService.instance.log('[GamesCubit] No games selected');
        return false;
      }
      
      emit(currentState.copyWith(isApplying: true));
      
      final result = await _removeLsfgUseCase(selectedIds);
      
      return result.fold(
        (failure) {
          emit(GamesState.error(message: failure.message));
          return false;
        },
        (_) {
          loadGames();
          return true;
        },
      );
    }
    return false;
  }
  
  /// Apply LSFG to a single game by ID.
  /// Returns true if successful.
  Future<bool> applyLsfgToGame(String gameId) async {
    final currentState = state;
    if (currentState is GamesLoaded) {
      emit(currentState.copyWith(isApplying: true));
      
      final result = await _applyLsfgUseCase([gameId]);
      
      return result.fold(
        (failure) {
          emit(GamesState.error(message: failure.message));
          return false;
        },
        (_) {
          loadGames();
          return true;
        },
      );
    }
    return false;
  }
  
  /// Remove LSFG from a single game by ID.
  /// Returns true if successful.
  Future<bool> removeLsfgFromGame(String gameId) async {
    final currentState = state;
    if (currentState is GamesLoaded) {
      emit(currentState.copyWith(isApplying: true));
      
      final result = await _removeLsfgUseCase([gameId]);
      
      return result.fold(
        (failure) {
          emit(GamesState.error(message: failure.message));
          return false;
        },
        (_) {
          loadGames();
          return true;
        },
      );
    }
    return false;
  }
}
