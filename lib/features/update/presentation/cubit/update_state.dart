import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heroic_lsfg_applier/features/update/domain/entities/update_info.dart';

part 'update_state.freezed.dart';

/// State for the update feature
@freezed
class UpdateState with _$UpdateState {
  /// Initial state, not checked yet
  const factory UpdateState.initial() = UpdateInitial;
  
  /// Checking for updates
  const factory UpdateState.checking() = UpdateChecking;
  
  /// Update is available
  const factory UpdateState.updateAvailable(UpdateInfo info) = UpdateIsAvailable;
  
  /// Already on latest version
  const factory UpdateState.upToDate(String version) = UpdateUpToDate;
  
  /// Downloading update
  const factory UpdateState.downloading({
    required UpdateInfo info,
    required int bytesReceived,
    required int totalBytes,
  }) = UpdateDownloading;
  
  /// Extracting downloaded archive
  const factory UpdateState.extracting({required UpdateInfo info}) = UpdateExtracting;
  
  /// Installing update
  const factory UpdateState.installing({required UpdateInfo info}) = UpdateInstalling;
  
  /// Update completed, ready for restart
  const factory UpdateState.completed({required UpdateInfo info}) = UpdateIsCompleted;
  
  /// Error occurred
  const factory UpdateState.error(String message) = UpdateError;
}
