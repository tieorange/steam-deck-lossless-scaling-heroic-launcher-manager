import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heroic_lsfg_applier/features/games/domain/entities/game_entity.dart';

part 'games_state.freezed.dart';

enum LsfgFilter { all, enabled, disabled }

/// State for the games list page
@freezed
class GamesState with _$GamesState {
  /// Initial loading state
  const factory GamesState.loading() = GamesLoading;
  
  /// Successfully loaded games
  const factory GamesState.loaded({
    required List<Game> games,
    required List<Game> filteredGames,
    @Default('') String searchQuery,
    @Default(LsfgFilter.all) LsfgFilter lsfgFilter,
    @Default(false) bool isApplying,

  }) = GamesLoaded;
  
  /// Error state
  const factory GamesState.error({
    required String message,
  }) = GamesError;
}
