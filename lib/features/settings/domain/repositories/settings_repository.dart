import 'package:dartz/dartz.dart';
import 'package:heroic_lsfg_applier/core/error/failures.dart';
import 'package:heroic_lsfg_applier/features/settings/domain/entities/settings_entity.dart';

/// Repository for managing app settings
abstract class SettingsRepository {
  /// Get current settings
  Future<Result<Settings>> getSettings();
  
  /// Save settings
  Future<Result<Unit>> saveSettings(Settings settings);
}
