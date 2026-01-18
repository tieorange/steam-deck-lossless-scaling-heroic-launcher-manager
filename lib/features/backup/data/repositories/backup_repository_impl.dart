import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:heroic_lsfg_applier/core/error/failures.dart';
import 'package:heroic_lsfg_applier/core/logging/logger_service.dart';
import 'package:heroic_lsfg_applier/core/platform/platform_service.dart';
import 'package:heroic_lsfg_applier/features/backup/domain/entities/backup_entity.dart';
import 'package:heroic_lsfg_applier/features/backup/domain/repositories/backup_repository.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

/// Implementation of BackupRepository using local file system.
///
/// Backs up configurations from all supported sources:
/// - Heroic Games Launcher (JSON configs)
/// - Lutris (YAML configs)
/// - Steam shortcuts (VDF files for OGI)
class BackupRepositoryImpl implements BackupRepository {
  final PlatformService _platformService;

  // Subdirectory names within each backup
  static const _heroicSubdir = 'heroic';
  static const _lutrisSubdir = 'lutris';
  static const _steamSubdir = 'steam_shortcuts';

  BackupRepositoryImpl(this._platformService);

  @override
  Future<Result<List<Backup>>> getBackups() async {
    try {
      final backupDir = Directory(_platformService.backupBasePath);

      if (!await backupDir.exists()) {
        return const Right([]);
      }

      final backups = <Backup>[];

      await for (final entity in backupDir.list()) {
        if (entity is Directory) {
          final backup = _parseBackupDirectory(entity);
          if (backup != null) {
            backups.add(backup);
          }
        }
      }

      // Sort by date, newest first
      backups.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return Right(backups);
    } catch (e) {
      return Left(BackupFailure('Failed to read backups: $e'));
    }
  }

  Backup? _parseBackupDirectory(Directory dir) {
    final name = p.basename(dir.path);

    // Parse backup name format: backup_YYYY-MM-DD_HH-mm-ss
    final regex = RegExp(r'backup_(\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2})');
    final match = regex.firstMatch(name);

    if (match != null) {
      final dateStr = match.group(1)!;
      try {
        final dateFormat = DateFormat('yyyy-MM-dd_HH-mm-ss');
        final date = dateFormat.parse(dateStr);
        return Backup(name: name, path: dir.path, createdAt: date);
      } catch (_) {
        // Fall through to use file stats
      }
    }

    // Fallback: use directory modification time
    try {
      final stat = dir.statSync();
      return Backup(name: name, path: dir.path, createdAt: stat.modified);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Result<Backup>> createBackup() async {
    try {
      LoggerService.instance.log('[BackupRepository] Creating comprehensive backup...');

      // Create backup base directory
      final backupBaseDir = Directory(_platformService.backupBasePath);
      if (!await backupBaseDir.exists()) {
        await backupBaseDir.create(recursive: true);
      }

      // Create timestamped backup folder
      final now = DateTime.now();
      final dateFormat = DateFormat('yyyy-MM-dd_HH-mm-ss');
      final backupName = 'backup_${dateFormat.format(now)}';
      final backupPath = '${backupBaseDir.path}/$backupName';
      final backupDir = Directory(backupPath);

      await backupDir.create();

      int filesCopied = 0;

      // 1. Backup Heroic configs
      final heroicSource = Directory(_platformService.gameConfigPath);
      if (await heroicSource.exists()) {
        final heroicDest = Directory('$backupPath/$_heroicSubdir');
        await heroicDest.create();
        final count = await _copyDirectory(heroicSource, heroicDest);
        filesCopied += count;
        LoggerService.instance.log('[BackupRepository] Backed up $count Heroic config files');
      }

      // 2. Backup Lutris configs
      final lutrisSource = Directory(_platformService.lutrisConfigPath);
      if (await lutrisSource.exists()) {
        final lutrisDest = Directory('$backupPath/$_lutrisSubdir');
        await lutrisDest.create();
        final count = await _copyDirectory(lutrisSource, lutrisDest);
        filesCopied += count;
        LoggerService.instance.log('[BackupRepository] Backed up $count Lutris config files');
      }

      // 3. Backup Steam shortcuts (for OGI)
      final steamShortcuts = await _findShortcutsFiles();
      if (steamShortcuts.isNotEmpty) {
        final steamDest = Directory('$backupPath/$_steamSubdir');
        await steamDest.create();
        for (final file in steamShortcuts) {
          // Preserve user ID in filename to restore correctly
          final userId = p.basename(p.dirname(p.dirname(file.path)));
          final destPath = '${steamDest.path}/${userId}_shortcuts.vdf';
          await file.copy(destPath);
          filesCopied++;
        }
        LoggerService.instance.log(
          '[BackupRepository] Backed up ${steamShortcuts.length} Steam shortcuts files',
        );
      }

      if (filesCopied == 0) {
        // No files found to backup - cleanup empty directory
        await backupDir.delete();
        return const Left(BackupFailure('No configuration files found to backup'));
      }

      LoggerService.instance.log(
        '[BackupRepository] Backup complete: $backupName ($filesCopied files)',
      );

      return Right(Backup(name: backupName, path: backupPath, createdAt: now));
    } catch (e, stack) {
      LoggerService.instance.error('[BackupRepository] Failed to create backup', e, stack);
      return Left(BackupFailure('Failed to create backup: $e'));
    }
  }

  @override
  Future<Result<Unit>> restoreBackup(Backup backup) async {
    try {
      LoggerService.instance.log('[BackupRepository] Restoring backup: ${backup.name}');

      final backupDir = Directory(backup.path);

      if (!await backupDir.exists()) {
        return Left(BackupFailure('Backup not found: ${backup.name}'));
      }

      int filesRestored = 0;

      // Check if this is a new-format backup (with subdirectories) or old-format
      final heroicBackup = Directory('${backup.path}/$_heroicSubdir');
      final isNewFormat = await heroicBackup.exists();

      if (isNewFormat) {
        // New format: restore from subdirectories

        // 1. Restore Heroic configs
        if (await heroicBackup.exists()) {
          final targetDir = Directory(_platformService.gameConfigPath);
          await _clearAndRestoreDirectory(heroicBackup, targetDir, ['.json']);
          filesRestored++;
          LoggerService.instance.log('[BackupRepository] Restored Heroic configs');
        }

        // 2. Restore Lutris configs
        final lutrisBackup = Directory('${backup.path}/$_lutrisSubdir');
        if (await lutrisBackup.exists()) {
          final targetDir = Directory(_platformService.lutrisConfigPath);
          await _clearAndRestoreDirectory(lutrisBackup, targetDir, ['.yml', '.yaml']);
          filesRestored++;
          LoggerService.instance.log('[BackupRepository] Restored Lutris configs');
        }

        // 3. Restore Steam shortcuts
        final steamBackup = Directory('${backup.path}/$_steamSubdir');
        if (await steamBackup.exists()) {
          await for (final entity in steamBackup.list()) {
            if (entity is File && entity.path.endsWith('.vdf')) {
              // Extract user ID from filename (format: {userId}_shortcuts.vdf)
              final filename = p.basenameWithoutExtension(entity.path);
              final userId = filename.replaceAll('_shortcuts', '');

              // Find which steam path contains this user
              String? targetUserDataPath;
              for (final path in _platformService.steamUserDataPaths) {
                if (await Directory('$path/$userId').exists()) {
                  targetUserDataPath = path;
                  break;
                }
              }

              // If not found, default to first path or skip?
              // Let's default to first path if list is not empty
              if (targetUserDataPath == null && _platformService.steamUserDataPaths.isNotEmpty) {
                targetUserDataPath = _platformService.steamUserDataPaths.first;
              }

              if (targetUserDataPath != null) {
                final targetPath = '$targetUserDataPath/$userId/config/shortcuts.vdf';
                final targetFile = File(targetPath);

                // Ensure parent config dir exists
                if (!await targetFile.parent.exists()) {
                  await targetFile.parent.create(recursive: true);
                }

                await entity.copy(targetPath);
                filesRestored++;
                LoggerService.instance.log(
                  '[BackupRepository] Restored shortcuts for user $userId to $targetPath',
                );
              } else {
                LoggerService.instance.log(
                  '[BackupRepository] Could not find steam path for user $userId',
                );
              }
            }
          }
        }
      } else {
        // Old format: direct files in backup directory (Heroic only)
        final targetDir = Directory(_platformService.gameConfigPath);
        await _clearAndRestoreDirectory(backupDir, targetDir, ['.json']);
        filesRestored++;
        LoggerService.instance.log('[BackupRepository] Restored from legacy backup format');
      }

      LoggerService.instance.log('[BackupRepository] Restore complete ($filesRestored operations)');
      return const Right(unit);
    } catch (e, stack) {
      LoggerService.instance.error('[BackupRepository] Failed to restore backup', e, stack);
      return Left(BackupFailure('Failed to restore backup: $e'));
    }
  }

  @override
  Future<Result<Unit>> deleteBackup(Backup backup) async {
    try {
      final backupDir = Directory(backup.path);

      if (await backupDir.exists()) {
        await backupDir.delete(recursive: true);
        LoggerService.instance.log('[BackupRepository] Deleted backup: ${backup.name}');
      }

      return const Right(unit);
    } catch (e) {
      return Left(BackupFailure('Failed to delete backup: $e'));
    }
  }

  /// Copies a directory recursively and returns the count of files copied.
  Future<int> _copyDirectory(Directory source, Directory destination) async {
    int count = 0;
    await for (final entity in source.list(recursive: false)) {
      final newPath = '${destination.path}/${p.basename(entity.path)}';

      if (entity is File) {
        await entity.copy(newPath);
        count++;
      } else if (entity is Directory) {
        final newDir = Directory(newPath);
        await newDir.create();
        count += await _copyDirectory(entity, newDir);
      }
    }
    return count;
  }

  /// Clears matching files in target directory and restores from source.
  Future<void> _clearAndRestoreDirectory(
    Directory source,
    Directory target,
    List<String> extensions,
  ) async {
    // Clear existing files with matching extensions
    if (await target.exists()) {
      await for (final entity in target.list()) {
        if (entity is File) {
          final ext = p.extension(entity.path).toLowerCase();
          if (extensions.contains(ext)) {
            await entity.delete();
          }
        }
      }
    } else {
      await target.create(recursive: true);
    }

    // Copy backup files to target
    await _copyDirectory(source, target);
  }

  /// Finds all shortcuts.vdf files in Steam userdata.
  Future<List<File>> _findShortcutsFiles() async {
    final results = <File>[];

    for (final userDataPath in _platformService.steamUserDataPaths) {
      final dir = Directory(userDataPath);
      if (!await dir.exists()) continue;

      try {
        final users = await dir.list().toList();
        for (final userDir in users) {
          if (userDir is Directory) {
            final vdfPath = p.join(userDir.path, 'config', 'shortcuts.vdf');
            final vdfFile = File(vdfPath);
            if (await vdfFile.exists()) {
              results.add(vdfFile);
            }
          }
        }
      } catch (e) {
        LoggerService.instance.log(
          '[BackupRepository] Error finding Steam users in $userDataPath: $e',
        );
      }
    }
    return results;
  }
}
