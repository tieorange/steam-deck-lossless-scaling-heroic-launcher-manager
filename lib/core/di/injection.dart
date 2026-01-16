import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:heroic_lsfg_applier/core/platform/platform_service.dart';
import 'package:heroic_lsfg_applier/core/services/vdf_binary_service.dart';
import 'package:heroic_lsfg_applier/features/backup/data/repositories/backup_repository_impl.dart';
import 'package:heroic_lsfg_applier/features/backup/data/repositories/mock_backup_repository.dart';
import 'package:heroic_lsfg_applier/features/backup/domain/repositories/backup_repository.dart';
import 'package:heroic_lsfg_applier/features/games/data/datasources/lutris_datasource.dart';
import 'package:heroic_lsfg_applier/features/games/data/datasources/ogi_datasource.dart';
import 'package:heroic_lsfg_applier/features/games/data/repositories/game_repository_impl.dart';
import 'package:heroic_lsfg_applier/features/games/data/repositories/mock_game_repository.dart';
import 'package:heroic_lsfg_applier/features/games/domain/repositories/game_repository.dart';
import 'package:heroic_lsfg_applier/features/games/domain/usecases/apply_lsfg_usecase.dart';
import 'package:heroic_lsfg_applier/features/games/domain/usecases/remove_lsfg_usecase.dart';
import 'package:heroic_lsfg_applier/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:heroic_lsfg_applier/features/settings/domain/repositories/settings_repository.dart';

/// Global service locator instance
final getIt = GetIt.instance;

/// Configures all dependencies for the application.
/// 
/// Call this once during app startup, before runApp().
Future<void> configureDependencies(SharedPreferences prefs) async {
  // ============ Core Services ============
  
  // Platform service - auto-detects Mac vs Linux
  getIt.registerSingleton<PlatformService>(createPlatformService());
  
  // VDF binary parser for Steam shortcuts
  getIt.registerLazySingleton<VdfBinaryService>(() => VdfBinaryService());
  
  // ============ Datasources ============
  
  getIt.registerLazySingleton<OgiDatasource>(
    () => OgiDatasource(getIt<PlatformService>()),
  );
  
  getIt.registerLazySingleton<LutrisDatasource>(
    () => LutrisDatasource(getIt<PlatformService>()),
  );
  
  // ============ Repositories ============
  
  // Determine if we should use mock repositories (macOS development)
  final useMocks = _shouldUseMockRepository();
  
  if (useMocks) {
    getIt.registerLazySingleton<GameRepository>(() => MockGameRepository());
    getIt.registerLazySingleton<BackupRepository>(() => MockBackupRepository());
  } else {
    getIt.registerLazySingleton<GameRepository>(
      () => GameRepositoryImpl(getIt<PlatformService>()),
    );
    getIt.registerLazySingleton<BackupRepository>(
      () => BackupRepositoryImpl(getIt<PlatformService>()),
    );
  }
  
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(prefs),
  );
  
  // ============ Use Cases ============
  
  getIt.registerLazySingleton<ApplyLsfgUseCase>(
    () => ApplyLsfgUseCase(
      getIt<GameRepository>(),
      getIt<BackupRepository>(),
      getIt<SettingsRepository>(),
    ),
  );
  
  getIt.registerLazySingleton<RemoveLsfgUseCase>(
    () => RemoveLsfgUseCase(getIt<GameRepository>()),
  );
}

/// Determines if mock repositories should be used.
/// 
/// Returns true on macOS when no test data directory exists,
/// allowing easy development without real game configs.
bool _shouldUseMockRepository() {
  if (!Platform.isMacOS) return false;
  
  final home = Platform.environment['HOME'] ?? '';
  final testDir = Directory('$home/HeroicTest');
  
  // Use mocks if test directory doesn't exist
  return !testDir.existsSync();
}

/// Convenience function to check if using mocks (for UI indicators)
bool shouldUseMockRepository() => _shouldUseMockRepository();
