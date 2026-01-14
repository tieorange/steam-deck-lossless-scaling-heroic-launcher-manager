import 'package:dartz/dartz.dart';
import 'package:heroic_lsfg_applier/core/error/failures.dart';
import 'package:heroic_lsfg_applier/features/backup/domain/entities/backup_entity.dart';

/// Repository interface for backup operations
abstract class BackupRepository {
  /// Get all existing backups
  Future<Result<List<Backup>>> getBackups();
  
  /// Create a new backup of game configs
  Future<Result<Backup>> createBackup();
  
  /// Restore a backup (overwrites current configs)
  Future<Result<Unit>> restoreBackup(Backup backup);
  
  /// Delete a backup
  Future<Result<Unit>> deleteBackup(Backup backup);
}
