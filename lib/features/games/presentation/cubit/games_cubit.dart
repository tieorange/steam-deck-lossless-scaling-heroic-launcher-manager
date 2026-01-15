import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroic_lsfg_applier/features/games/domain/repositories/game_repository.dart';
import 'package:heroic_lsfg_applier/features/backup/domain/repositories/backup_repository.dart';
import 'package:heroic_lsfg_applier/features/settings/domain/repositories/settings_repository.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/cubit/games_state.dart';
import 'package:heroic_lsfg_applier/features/settings/domain/entities/settings_entity.dart';
import 'package:heroic_lsfg_applier/core/logging/logger_service.dart';
import 'package:heroic_lsfg_applier/features/games/domain/entities/game_entity.dart';

/// Cubit for managing games list state
class GamesCubit extends Cubit<GamesState> {
  final GameRepository _gameRepository;
  final SettingsRepository _settingsRepository;
  final BackupRepository _backupRepository;
  
  GamesCubit(
    this._gameRepository,
    this._settingsRepository,
    this._backupRepository,
  ) : super(const GamesState.loading());
  
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
      bool matchesLsfg = true;
      switch (filter) {
        case LsfgFilter.all:
          matchesLsfg = true;
          break;
        case LsfgFilter.enabled:
          matchesLsfg = game.hasLsfgEnabled;
          break;
        case LsfgFilter.disabled:
          matchesLsfg = !game.hasLsfgEnabled;
          break;
      }
      
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
      

      
      // Auto-backup if enabled
      try {
        final settingsResult = await _settingsRepository.getSettings();
        final shouldBackup = settingsResult.getOrElse(() => const Settings()).autoBackup;
        
        if (shouldBackup) {
          LoggerService.instance.log('[GamesCubit] Auto-backup enabled, creating backup...');
          final backupResult = await _backupRepository.createBackup();
          backupResult.fold(
            (failure) => LoggerService.instance.log('[GamesCubit] Auto-backup failed: ${failure.message}'), // Non-fatal?
            (backup) => LoggerService.instance.log('[GamesCubit] Auto-backup created: ${backup.name}'),
          );
        }
      } catch (e) {
        LoggerService.instance.log('[GamesCubit] Error checking settings for auto-backup: $e');
      }
      
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
