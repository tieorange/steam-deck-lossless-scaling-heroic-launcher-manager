/// Application-wide constants.
/// 
/// Centralizes strings and values that are used across multiple files.
class AppConstants {
  AppConstants._();
  
  /// Application name
  static const appName = 'Heroic LSFG Applier';
  
  /// Log file name (stored in app documents directory)
  static const logFileName = 'heroic_lsfg_logs.txt';
  
  /// Version string (should match pubspec.yaml)
  static const version = '1.0.0';
}

/// Game source identifiers.
/// 
/// These prefixes are used to create unique game IDs across different
/// launchers (e.g., "heroic:game123", "ogi:456", "lutris:my-game").
class GameSourceId {
  GameSourceId._();
  
  /// Heroic Games Launcher source
  static const heroic = 'heroic';
  
  /// OpenGameInstaller source
  static const ogi = 'ogi';
  
  /// Lutris source
  static const lutris = 'lutris';
  
  /// Formats a game ID with source prefix
  static String format(String source, String internalId) => '$source:$internalId';
  
  /// Parses a game ID to extract source and internal ID
  static (String source, String internalId) parse(String gameId) {
    final parts = gameId.split(':');
    if (parts.length < 2) {
      return (heroic, gameId); // Legacy format without prefix
    }
    return (parts[0], parts.sublist(1).join(':'));
  }
}

/// LSFG environment variable configuration.
/// 
/// These are also defined in PlatformService but duplicated here for
/// documentation and potential future customization.
class LsfgConfig {
  LsfgConfig._();
  
  /// Environment variable key
  static const envKey = 'LSFG_PROCESS';
  
  /// Environment variable value for decky-lsfg-vk
  static const envValue = 'decky-lsfg-vk';
  
  /// Full environment string for Steam launch options
  static String get launchEnv => '$envKey=$envValue';
}
