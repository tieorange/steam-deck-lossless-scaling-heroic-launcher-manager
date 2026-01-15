import 'dart:io';

/// Abstract service for platform-specific paths
/// Allows testing on macOS by using mock paths
abstract class PlatformService {
  /// Base path for Heroic config (contains GamesConfig folder)
  String get heroicConfigPath;
  
  /// Path to GamesConfig directory with individual game JSON files
  String get gameConfigPath;
  
  /// Path to Heroic icon cache
  String get iconCachePath;
  
  /// Base path for our app's backups
  String get backupBasePath;
  
  /// Check if Heroic config exists
  bool get heroicConfigExists => Directory(heroicConfigPath).existsSync();
  
  /// Environment variable key we're adding
  static const String lsfgEnvKey = 'LSFG_PROCESS';
  
  /// Environment variable value we're setting
  static const String lsfgEnvValue = 'decky-lsfg-vk';

  /// Path to OpenGameInstaller library
  String get ogiLibraryPath;

  /// Path to Steam user data (containing shortcuts.vdf)
  String get steamUserDataPath;
}

/// Linux implementation for real Steam Deck/Linux usage
class LinuxPlatformService extends PlatformService {
  late final String _homeDir;
  
  LinuxPlatformService() {
    _homeDir = Platform.environment['HOME'] ?? '/home/deck';
  }
  
  @override
  String get heroicConfigPath {
    // First check for Flatpak installation (more common)
    final flatpakPath = '$_homeDir/.var/app/com.heroicgameslauncher.hgl/config/heroic';
    if (Directory(flatpakPath).existsSync()) {
      return flatpakPath;
    }
    // Fallback to standard installation
    return '$_homeDir/.config/heroic';
  }
  
  @override
  String get gameConfigPath => '$heroicConfigPath/GamesConfig';
  
  @override
  String get iconCachePath => '$heroicConfigPath/store';
  
  @override
  String get backupBasePath => '$_homeDir/.config/heroic_lsfg_applier/backups';

  @override
  String get ogiLibraryPath => '$_homeDir/.local/share/OpenGameInstaller/library';

  @override
  String get steamUserDataPath => '$_homeDir/.steam/steam/userdata';
}

/// macOS implementation for development/testing
class MacOSPlatformService extends PlatformService {
  late final String _homeDir;
  
  MacOSPlatformService() {
    _homeDir = Platform.environment['HOME'] ?? '/Users/user';
  }
  
  @override
  String get heroicConfigPath => '$_homeDir/HeroicTest/config/heroic';
  
  @override
  String get gameConfigPath => '$heroicConfigPath/GamesConfig';
  
  @override
  String get iconCachePath => '$heroicConfigPath/store';
  
  @override
  String get backupBasePath => '$_homeDir/HeroicTest/heroic_lsfg_applier/backups';

  @override
  String get ogiLibraryPath => '$_homeDir/HeroicTest/OpenGameInstaller/library';

  @override
  String get steamUserDataPath => '$_homeDir/HeroicTest/Steam/userdata';
}

/// Factory to create the appropriate platform service
PlatformService createPlatformService() {
  if (Platform.isMacOS) {
    return MacOSPlatformService();
  }
  return LinuxPlatformService();
}
