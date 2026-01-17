import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_info.freezed.dart';
part 'update_info.g.dart';

/// Information about an available update
@freezed
class UpdateInfo with _$UpdateInfo {
  const factory UpdateInfo({
    /// Version tag (e.g., "v1.0.1" or "1.0.1")
    required String version,
    
    /// Release notes / changelog
    required String releaseNotes,
    
    /// Download URL for the Linux release asset
    required String downloadUrl,
    
    /// Size of the download in bytes (if available)
    int? downloadSize,
    
    /// Release date
    DateTime? releaseDate,
    
    /// Whether this is a prerelease
    @Default(false) bool isPrerelease,
  }) = _UpdateInfo;

  factory UpdateInfo.fromJson(Map<String, dynamic> json) => _$UpdateInfoFromJson(json);
}

/// Result of checking for updates
@freezed
class UpdateCheckResult with _$UpdateCheckResult {
  /// Update is available
  const factory UpdateCheckResult.available(UpdateInfo info) = UpdateAvailable;
  
  /// Already on latest version
  const factory UpdateCheckResult.upToDate(String currentVersion) = UpToDate;
  
  /// Check failed with error
  const factory UpdateCheckResult.error(String message) = UpdateError;
}

/// State of an in-progress update
@freezed
class UpdateProgress with _$UpdateProgress {
  /// Download progress
  const factory UpdateProgress.downloading({
    required int bytesReceived,
    required int totalBytes,
  }) = Downloading;
  
  /// Extracting downloaded archive
  const factory UpdateProgress.extracting() = Extracting;
  
  /// Installing updated files
  const factory UpdateProgress.installing() = Installing;
  
  /// Update completed, restart needed
  const factory UpdateProgress.completed() = UpdateCompleted;
  
  /// Update failed
  const factory UpdateProgress.failed(String message) = UpdateFailed;
}
