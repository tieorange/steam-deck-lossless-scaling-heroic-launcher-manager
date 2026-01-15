import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroic_lsfg_applier/features/games/domain/repositories/game_repository.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/cubit/games_state.dart';
import 'package:heroic_lsfg_applier/core/logging/logger_service.dart';

/// Cubit for managing games list state
class GamesCubit extends Cubit<GamesState> {
  final GameRepository _gameRepository;
  
  GamesCubit(this._gameRepository) : super(const GamesState.loading());
  
  /// Load all games from Heroic config
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
  
  /// Filter games by search query
  void search(String query) {
    final currentState = state;
    if (currentState is GamesLoaded) {
      final filtered = currentState.games.where((game) {
        return game.title.toLowerCase().contains(query.toLowerCase()) ||
               game.internalId.toLowerCase().contains(query.toLowerCase());
      }).toList();
      
      emit(currentState.copyWith(
        searchQuery: query,
        filteredGames: filtered,
      ));
    }
  }
  
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
  
  /// Apply LSFG to selected games
  /// Returns true if successful, false otherwise
  Future<bool> applyLsfgToSelected() async {
    final currentState = state;
    if (currentState is GamesLoaded) {
      final selectedIds = currentState.games
          .where((g) => g.isSelected)
          .map((g) => g.id)
          .toList();
      
      LoggerService.instance.log('[GamesCubit] applyLsfgToSelected called');
      LoggerService.instance.log('[GamesCubit] Selected games: $selectedIds');
      
      if (selectedIds.isEmpty) {
        LoggerService.instance.log('[GamesCubit] No games selected, returning false');
        return false;
      }
      
      emit(currentState.copyWith(isApplying: true));
      
      LoggerService.instance.log('[GamesCubit] Calling repository.applyLsfgToGames...');
      final result = await _gameRepository.applyLsfgToGames(selectedIds);
      
      bool success = false;
      result.fold(
        (failure) {
          LoggerService.instance.log('[GamesCubit] Apply failed: ${failure.message}');
          emit(GamesState.error(message: failure.message));
        },
        (_) {
          LoggerService.instance.log('[GamesCubit] Apply succeeded, reloading games...');
          success = true;
          loadGames(); // Reload to reflect changes
        },
      );
      return success;
    }
    LoggerService.instance.log('[GamesCubit] State is not GamesLoaded, returning false');
    return false;
  }
  
  /// Remove LSFG from selected games
  /// Returns true if successful, false otherwise
  Future<bool> removeLsfgFromSelected() async {
    final currentState = state;
    if (currentState is GamesLoaded) {
      final selectedIds = currentState.games
          .where((g) => g.isSelected)
          .map((g) => g.id)
          .toList();
      
      LoggerService.instance.log('[GamesCubit] removeLsfgFromSelected called');
      LoggerService.instance.log('[GamesCubit] Selected games: $selectedIds');
      
      if (selectedIds.isEmpty) {
        LoggerService.instance.log('[GamesCubit] No games selected, returning false');
        return false;
      }
      
      emit(currentState.copyWith(isApplying: true));
      
      LoggerService.instance.log('[GamesCubit] Calling repository.removeLsfgFromGames...');
      final result = await _gameRepository.removeLsfgFromGames(selectedIds);
      
      bool success = false;
      result.fold(
        (failure) {
          LoggerService.instance.log('[GamesCubit] Remove failed: ${failure.message}');
          emit(GamesState.error(message: failure.message));
        },
        (_) {
          LoggerService.instance.log('[GamesCubit] Remove succeeded, reloading games...');
          success = true;
          loadGames(); // Reload to reflect changes
        },
      );
      return success;
    }
    LoggerService.instance.log('[GamesCubit] State is not GamesLoaded, returning false');
    return false;
  }
  
  /// Get count of selected games
  int get selectedCount {
    final currentState = state;
    if (currentState is GamesLoaded) {
      return currentState.games.where((g) => g.isSelected).length;
    }
    return 0;
  }
}
