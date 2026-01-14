import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:heroic_lsfg_applier/core/error/failures.dart';
import 'package:heroic_lsfg_applier/core/platform/platform_service.dart';
import 'package:heroic_lsfg_applier/features/backup/domain/entities/backup_entity.dart';
import 'package:heroic_lsfg_applier/features/backup/domain/repositories/backup_repository.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

/// Implementation of BackupRepository using local file system
class BackupRepositoryImpl implements BackupRepository {
  final PlatformService _platformService;
  
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
        return Backup(
          name: name,
          path: dir.path,
          createdAt: date,
        );
      } catch (_) {
        // Fall through to use file stats
      }
    }
    
    // Fallback: use directory modification time
    try {
      final stat = dir.statSync();
      return Backup(
        name: name,
        path: dir.path,
        createdAt: stat.modified,
      );
    } catch (_) {
      return null;
    }
  }
  
  @override
  Future<Result<Backup>> createBackup() async {
    try {
      final sourceDir = Directory(_platformService.gameConfigPath);
      
      if (!await sourceDir.exists()) {
        return const Left(HeroicNotFoundFailure());
      }
      
      // Create backup directory
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
      
      // Copy all files recursively
      await _copyDirectory(sourceDir, backupDir);
      
      return Right(Backup(
        name: backupName,
        path: backupPath,
        createdAt: now,
      ));
    } catch (e) {
      return Left(BackupFailure('Failed to create backup: $e'));
    }
  }
  
  @override
  Future<Result<Unit>> restoreBackup(Backup backup) async {
    try {
      final backupDir = Directory(backup.path);
      
      if (!await backupDir.exists()) {
        return Left(BackupFailure('Backup not found: ${backup.name}'));
      }
      
      final targetDir = Directory(_platformService.gameConfigPath);
      
      // Clear existing configs
      if (await targetDir.exists()) {
        await for (final entity in targetDir.list()) {
          if (entity is File && entity.path.endsWith('.json')) {
            await entity.delete();
          }
        }
      } else {
        await targetDir.create(recursive: true);
      }
      
      // Copy backup files to target
      await _copyDirectory(backupDir, targetDir);
      
      return const Right(unit);
    } catch (e) {
      return Left(BackupFailure('Failed to restore backup: $e'));
    }
  }
  
  @override
  Future<Result<Unit>> deleteBackup(Backup backup) async {
    try {
      final backupDir = Directory(backup.path);
      
      if (await backupDir.exists()) {
        await backupDir.delete(recursive: true);
      }
      
      return const Right(unit);
    } catch (e) {
      return Left(BackupFailure('Failed to delete backup: $e'));
    }
  }
  
  Future<void> _copyDirectory(Directory source, Directory destination) async {
    await for (final entity in source.list(recursive: false)) {
      final newPath = '${destination.path}/${p.basename(entity.path)}';
      
      if (entity is File) {
        await entity.copy(newPath);
      } else if (entity is Directory) {
        final newDir = Directory(newPath);
        await newDir.create();
        await _copyDirectory(entity, newDir);
      }
    }
  }
}
