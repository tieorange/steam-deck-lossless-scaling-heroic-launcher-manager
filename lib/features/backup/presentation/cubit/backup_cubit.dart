import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroic_lsfg_applier/features/backup/domain/entities/backup_entity.dart';
import 'package:heroic_lsfg_applier/features/backup/domain/repositories/backup_repository.dart';
import 'package:heroic_lsfg_applier/features/backup/presentation/cubit/backup_state.dart';

/// Cubit for managing backup state
class BackupCubit extends Cubit<BackupState> {
  final BackupRepository _backupRepository;
  
  BackupCubit(this._backupRepository) : super(const BackupState.loading());
  
  /// Load all existing backups
  Future<void> loadBackups() async {
    emit(const BackupState.loading());
    
    final result = await _backupRepository.getBackups();
    
    result.fold(
      (failure) => emit(BackupState.error(message: failure.message)),
      (backups) => emit(BackupState.loaded(backups: backups)),
    );
  }
  
  /// Create a new backup
  Future<bool> createBackup() async {
    final currentState = state;
    if (currentState is BackupLoaded) {
      emit(currentState.copyWith(isCreating: true));
    }
    
    final result = await _backupRepository.createBackup();
    
    return result.fold(
      (failure) {
        emit(BackupState.error(message: failure.message));
        return false;
      },
      (backup) {
        loadBackups(); // Reload to include new backup
        return true;
      },
    );
  }
  
  /// Restore a backup
  Future<bool> restoreBackup(Backup backup) async {
    final currentState = state;
    if (currentState is BackupLoaded) {
      emit(currentState.copyWith(isRestoring: true));
    }
    
    final result = await _backupRepository.restoreBackup(backup);
    
    return result.fold(
      (failure) {
        emit(BackupState.error(message: failure.message));
        return false;
      },
      (_) {
        loadBackups();
        return true;
      },
    );
  }
  
  /// Delete a backup
  Future<bool> deleteBackup(Backup backup) async {
    final result = await _backupRepository.deleteBackup(backup);
    
    return result.fold(
      (failure) {
        emit(BackupState.error(message: failure.message));
        return false;
      },
      (_) {
        loadBackups();
        return true;
      },
    );
  }
}
