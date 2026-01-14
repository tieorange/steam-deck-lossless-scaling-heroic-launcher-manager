import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heroic_lsfg_applier/features/backup/domain/entities/backup_entity.dart';

part 'backup_state.freezed.dart';

/// State for the backup page
@freezed
class BackupState with _$BackupState {
  /// Initial loading state
  const factory BackupState.loading() = BackupLoading;
  
  /// Successfully loaded backups
  const factory BackupState.loaded({
    required List<Backup> backups,
    @Default(false) bool isCreating,
    @Default(false) bool isRestoring,
  }) = BackupLoaded;
  
  /// Error state
  const factory BackupState.error({
    required String message,
  }) = BackupError;
}
