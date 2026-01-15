import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_entity.freezed.dart';

/// Represents a game installed via Heroic Games Launcher
@freezed
class Game with _$Game {
  const factory Game({
    /// Unique game identifier (source:internalId)
    required String id,

    /// Original identifier from source (e.g. appName/slug/appID)
    required String internalId,
    
    /// Display title of the game
    required String title,
    
    /// Path to cached game icon (may be null)
    String? iconPath,
    
    /// Whether LSFG environment variable is already set
    required bool hasLsfgEnabled,
    
    /// Whether this game is selected in the UI
    @Default(false) bool isSelected,

    /// Source of the game (Heroic, OpenGameInstaller, etc.)
    @Default(GameType.heroic) GameType type,
  }) = _Game;
}

enum GameType {
  heroic,
  ogi,
  lutris,
}
