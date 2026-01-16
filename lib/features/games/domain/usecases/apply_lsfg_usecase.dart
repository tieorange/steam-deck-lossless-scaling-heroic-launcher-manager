import 'package:dartz/dartz.dart';
import 'package:heroic_lsfg_applier/core/error/failures.dart';
import 'package:heroic_lsfg_applier/core/logging/logger_service.dart';
import 'package:heroic_lsfg_applier/features/backup/domain/repositories/backup_repository.dart';
import 'package:heroic_lsfg_applier/features/games/domain/repositories/game_repository.dart';
import 'package:heroic_lsfg_applier/features/settings/domain/entities/settings_entity.dart';
import 'package:heroic_lsfg_applier/features/settings/domain/repositories/settings_repository.dart';

/// Use case for applying LSFG environment variable to games.
/// 
/// Encapsulates the business logic for:
/// - Optional auto-backup before applying changes
/// - Calling the repository to modify game configs
class ApplyLsfgUseCase {
  final GameRepository _gameRepository;
  final BackupRepository _backupRepository;
  final SettingsRepository _settingsRepository;
  
  ApplyLsfgUseCase(
    this._gameRepository,
    this._backupRepository,
    this._settingsRepository,
  );
  
  /// Applies LSFG to the specified games.
  /// 
  /// If [checkAutoBackup] is true (default), checks settings and creates
  /// a backup if auto-backup is enabled.
  Future<Result<Unit>> call(
    List<String> gameIds, {
    bool checkAutoBackup = true,
  }) async {
    LoggerService.instance.log('[ApplyLsfgUseCase] Applying LSFG to ${gameIds.length} games');
    
    // Auto-backup if enabled
    if (checkAutoBackup) {
      try {
        final settingsResult = await _settingsRepository.getSettings();
        final shouldBackup = settingsResult.getOrElse(() => const Settings()).autoBackup;
        
        if (shouldBackup) {
          LoggerService.instance.log('[ApplyLsfgUseCase] Auto-backup enabled, creating backup...');
          final backupResult = await _backupRepository.createBackup();
          backupResult.fold(
            (failure) => LoggerService.instance.log('[ApplyLsfgUseCase] Auto-backup failed: ${failure.message}'),
            (backup) => LoggerService.instance.log('[ApplyLsfgUseCase] Auto-backup created: ${backup.name}'),
          );
        }
      } catch (e) {
        LoggerService.instance.log('[ApplyLsfgUseCase] Error during auto-backup check: $e');
        // Non-fatal - continue with apply
      }
    }
    
    // Apply LSFG
    final result = await _gameRepository.applyLsfgToGames(gameIds);
    
    result.fold(
      (failure) => LoggerService.instance.log('[ApplyLsfgUseCase] Apply failed: ${failure.message}'),
      (_) => LoggerService.instance.log('[ApplyLsfgUseCase] Apply succeeded'),
    );
    
    return result;
  }
}
