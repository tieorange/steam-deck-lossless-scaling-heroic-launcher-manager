import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroic_lsfg_applier/features/games/domain/repositories/game_repository.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/cubit/games_state.dart';

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
               game.appName.toLowerCase().contains(query.toLowerCase());
      }).toList();
      
      emit(currentState.copyWith(
        searchQuery: query,
        filteredGames: filtered,
      ));
    }
  }
  
  /// Toggle selection of a single game
  void toggleGameSelection(String appName) {
    final currentState = state;
    if (currentState is GamesLoaded) {
      final updatedGames = currentState.games.map((game) {
        if (game.appName == appName) {
          return game.copyWith(isSelected: !game.isSelected);
        }
        return game;
      }).toList();
      
      final updatedFiltered = currentState.filteredGames.map((game) {
        if (game.appName == appName) {
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
      final visibleAppNames = currentState.filteredGames.map((g) => g.appName).toSet();
      
      final updatedGames = currentState.games.map((game) {
        if (visibleAppNames.contains(game.appName)) {
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
      final selectedAppNames = currentState.games
          .where((g) => g.isSelected)
          .map((g) => g.appName)
          .toList();
      
      debugPrint('[GamesCubit] applyLsfgToSelected called');
      debugPrint('[GamesCubit] Selected games: $selectedAppNames');
      
      if (selectedAppNames.isEmpty) {
        debugPrint('[GamesCubit] No games selected, returning false');
        return false;
      }
      
      emit(currentState.copyWith(isApplying: true));
      
      debugPrint('[GamesCubit] Calling repository.applyLsfgToGames...');
      final result = await _gameRepository.applyLsfgToGames(selectedAppNames);
      
      bool success = false;
      result.fold(
        (failure) {
          debugPrint('[GamesCubit] Apply failed: ${failure.message}');
          emit(GamesState.error(message: failure.message));
        },
        (_) {
          debugPrint('[GamesCubit] Apply succeeded, reloading games...');
          success = true;
          loadGames(); // Reload to reflect changes
        },
      );
      return success;
    }
    debugPrint('[GamesCubit] State is not GamesLoaded, returning false');
    return false;
  }
  
  /// Remove LSFG from selected games
  /// Returns true if successful, false otherwise
  Future<bool> removeLsfgFromSelected() async {
    final currentState = state;
    if (currentState is GamesLoaded) {
      final selectedAppNames = currentState.games
          .where((g) => g.isSelected)
          .map((g) => g.appName)
          .toList();
      
      debugPrint('[GamesCubit] removeLsfgFromSelected called');
      debugPrint('[GamesCubit] Selected games: $selectedAppNames');
      
      if (selectedAppNames.isEmpty) {
        debugPrint('[GamesCubit] No games selected, returning false');
        return false;
      }
      
      emit(currentState.copyWith(isApplying: true));
      
      debugPrint('[GamesCubit] Calling repository.removeLsfgFromGames...');
      final result = await _gameRepository.removeLsfgFromGames(selectedAppNames);
      
      bool success = false;
      result.fold(
        (failure) {
          debugPrint('[GamesCubit] Remove failed: ${failure.message}');
          emit(GamesState.error(message: failure.message));
        },
        (_) {
          debugPrint('[GamesCubit] Remove succeeded, reloading games...');
          success = true;
          loadGames(); // Reload to reflect changes
        },
      );
      return success;
    }
    debugPrint('[GamesCubit] State is not GamesLoaded, returning false');
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
