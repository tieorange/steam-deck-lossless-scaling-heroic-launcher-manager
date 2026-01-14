import 'package:freezed_annotation/freezed_annotation.dart';

part 'backup_entity.freezed.dart';

/// Represents a backup of Heroic game configs
@freezed
class Backup with _$Backup {
  const factory Backup({
    /// Display name of the backup (folder name)
    required String name,
    
    /// Full path to backup directory
    required String path,
    
    /// When the backup was created
    required DateTime createdAt,
  }) = _Backup;
}
