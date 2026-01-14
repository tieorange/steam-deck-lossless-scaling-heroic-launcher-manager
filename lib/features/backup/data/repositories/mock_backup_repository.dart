import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:heroic_lsfg_applier/core/error/failures.dart';
import 'package:heroic_lsfg_applier/features/backup/domain/entities/backup_entity.dart';
import 'package:heroic_lsfg_applier/features/backup/domain/repositories/backup_repository.dart';

/// Mock repository for testing backups on macOS
class MockBackupRepository implements BackupRepository {
  final List<Backup> _mockBackups = [];
  
  @override
  Future<Result<List<Backup>>> getBackups() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Sort by date, newest first
    _mockBackups.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return Right(List.from(_mockBackups));
  }
  
  @override
  Future<Result<Backup>> createBackup() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final now = DateTime.now();
    final name = 'backup_${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_'
        '${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}-${now.second.toString().padLeft(2, '0')}';
    
    final backup = Backup(
      name: name,
      path: '/mock/backups/$name',
      createdAt: now,
    );
    
    _mockBackups.add(backup);
    
    return Right(backup);
  }
  
  @override
  Future<Result<Unit>> restoreBackup(Backup backup) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Just simulate success
    return const Right(unit);
  }
  
  @override
  Future<Result<Unit>> deleteBackup(Backup backup) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    _mockBackups.removeWhere((b) => b.name == backup.name);
    
    return const Right(unit);
  }
}

/// Check if we should use mock backup repository
bool shouldUseMockBackupRepository() {
  if (!Platform.isMacOS) return false;
  
  final homeDir = Platform.environment['HOME'] ?? '/Users/user';
  final mockPath = '$homeDir/HeroicTest/config/heroic/GamesConfig';
  
  return !Directory(mockPath).existsSync();
}
