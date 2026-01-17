import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:heroic_lsfg_applier/core/logging/logger_service.dart';
import 'package:heroic_lsfg_applier/features/update/domain/entities/update_info.dart';

/// Service for checking and applying app updates from GitHub Releases
class UpdateService {
  static final UpdateService _instance = UpdateService._internal();
  factory UpdateService() => _instance;
  UpdateService._internal();

  // Configuration
  static const String _repoOwner = 'tieorange';
  static const String _repoName = 'steam-deck-lossless-scaling-heroic-launcher-manager';
  static const String _assetPattern = 'linux';  // Match assets containing this
  
  final _log = LoggerService.instance;
  final HttpClient _httpClient = HttpClient();
  
  /// Current app version (from pubspec.yaml)
  String get currentVersion => '1.0.0';  // TODO: Consider reading from package_info_plus
  
  /// Check for updates from GitHub Releases
  Future<UpdateCheckResult> checkForUpdates() async {
    try {
      _log.log('[Update] Checking for updates...');
      
      final uri = Uri.parse(
        'https://api.github.com/repos/$_repoOwner/$_repoName/releases/latest'
      );
      
      final request = await _httpClient.getUrl(uri);
      request.headers.add('Accept', 'application/vnd.github.v3+json');
      request.headers.add('User-Agent', 'HeroicLSFGApplier/$currentVersion');
      
      final response = await request.close();
      
      if (response.statusCode != 200) {
        final body = await response.transform(utf8.decoder).join();
        _log.log('[Update] GitHub API returned ${response.statusCode}: $body');
        return UpdateCheckResult.error('Failed to check for updates (HTTP ${response.statusCode})');
      }
      
      final body = await response.transform(utf8.decoder).join();
      final json = jsonDecode(body) as Map<String, dynamic>;
      
      final tagName = json['tag_name'] as String? ?? '';
      final latestVersion = _normalizeVersion(tagName);
      final currentNormalized = _normalizeVersion(currentVersion);
      
      _log.log('[Update] Current: $currentNormalized, Latest: $latestVersion');
      
      if (_isNewerVersion(latestVersion, currentNormalized)) {
        // Find Linux asset
        final assets = json['assets'] as List<dynamic>? ?? [];
        String? downloadUrl;
        int? downloadSize;
        
        for (final asset in assets) {
          final name = (asset['name'] as String? ?? '').toLowerCase();
          if (name.contains(_assetPattern) && name.endsWith('.zip')) {
            downloadUrl = asset['browser_download_url'] as String?;
            downloadSize = asset['size'] as int?;
            break;
          }
        }
        
        if (downloadUrl == null) {
          _log.log('[Update] No Linux asset found in release');
          return const UpdateCheckResult.error('No compatible release found');
        }
        
        final releaseDateStr = json['published_at'] as String?;
        
        return UpdateCheckResult.available(UpdateInfo(
          version: tagName,
          releaseNotes: json['body'] as String? ?? 'No release notes available.',
          downloadUrl: downloadUrl,
          downloadSize: downloadSize,
          releaseDate: releaseDateStr != null ? DateTime.tryParse(releaseDateStr) : null,
          isPrerelease: json['prerelease'] as bool? ?? false,
        ));
      }
      
      return UpdateCheckResult.upToDate(currentVersion);
    } catch (e, stack) {
      _log.error('[Update] Failed to check for updates: $e', e, stack);
      return UpdateCheckResult.error('Failed to check for updates: $e');
    }
  }
  
  /// Download and install an update
  /// Returns a stream of progress updates
  Stream<UpdateProgress> downloadAndInstall(UpdateInfo info) async* {
    try {
      _log.log('[Update] Starting update to ${info.version}');
      
      // Get temp directory
      final tempDir = Directory.systemTemp.createTempSync('heroic_lsfg_update_');
      final archivePath = '${tempDir.path}/update.zip';
      
      try {
        // Download
        yield UpdateProgress.downloading(bytesReceived: 0, totalBytes: info.downloadSize ?? 0);
        
        final uri = Uri.parse(info.downloadUrl);
        final request = await _httpClient.getUrl(uri);
        final response = await request.close();
        
        if (response.statusCode != 200) {
          yield UpdateProgress.failed('Download failed (HTTP ${response.statusCode})');
          return;
        }
        
        final file = File(archivePath);
        final sink = file.openWrite();
        int bytesReceived = 0;
        final totalBytes = response.contentLength > 0 ? response.contentLength : (info.downloadSize ?? 0);
        
        await for (final chunk in response) {
          sink.add(chunk);
          bytesReceived += chunk.length;
          yield UpdateProgress.downloading(bytesReceived: bytesReceived, totalBytes: totalBytes);
        }
        
        await sink.close();
        _log.log('[Update] Download complete: ${file.lengthSync()} bytes');
        
        // Extract
        yield const UpdateProgress.extracting();
        
        final extractDir = Directory('${tempDir.path}/extract');
        await extractDir.create();
        
        final unzipResult = await Process.run('unzip', ['-q', archivePath, '-d', extractDir.path]);
        if (unzipResult.exitCode != 0) {
          yield UpdateProgress.failed('Extraction failed: ${unzipResult.stderr}');
          return;
        }
        
        // Find the bundle directory
        final bundleDir = await _findBundleDir(extractDir);
        if (bundleDir == null) {
          yield UpdateProgress.failed('Could not find application in archive');
          return;
        }
        
        // Install
        yield const UpdateProgress.installing();
        
        final installDir = _getInstallDir();
        if (installDir == null) {
          yield UpdateProgress.failed('Could not determine install directory');
          return;
        }
        
        // Backup current installation
        final backupDir = Directory('$installDir.bak');
        if (await backupDir.exists()) {
          await backupDir.delete(recursive: true);
        }
        
        final currentInstall = Directory(installDir);
        if (await currentInstall.exists()) {
          await currentInstall.rename(backupDir.path);
        }
        
        // Copy new files
        await currentInstall.create(recursive: true);
        await _copyDirectory(bundleDir, currentInstall);
        
        // Save version info
        final versionFile = File('$installDir/version.txt');
        await versionFile.writeAsString(info.version);
        
        // Make executable
        final executable = File('$installDir/heroic_lsfg_applier');
        if (await executable.exists()) {
          await Process.run('chmod', ['+x', executable.path]);
        }
        
        // Remove backup on success
        if (await backupDir.exists()) {
          await backupDir.delete(recursive: true);
        }
        
        _log.log('[Update] Update installed successfully');
        yield const UpdateProgress.completed();
        
      } finally {
        // Cleanup temp directory
        try {
          await tempDir.delete(recursive: true);
        } catch (_) {}
      }
    } catch (e, stack) {
      _log.error('[Update] Update failed: $e', e, stack);
      yield UpdateProgress.failed('Update failed: $e');
    }
  }
  
  /// Get the installation directory
  String? _getInstallDir() {
    // Check if running from installed location
    final execPath = Platform.resolvedExecutable;
    final execDir = Directory(execPath).parent.path;
    
    // If in standard install location, use that
    final homeDir = Platform.environment['HOME'] ?? '';
    final standardPath = '$homeDir/.local/share/heroic_lsfg_applier';
    
    if (execDir.contains('.local/share/heroic_lsfg_applier')) {
      return standardPath;
    }
    
    // Otherwise use standard path for new installs
    return standardPath;
  }
  
  /// Find the bundle directory in extracted archive
  Future<Directory?> _findBundleDir(Directory extractDir) async {
    // Check if executable is directly in extract dir
    if (await File('${extractDir.path}/heroic_lsfg_applier').exists()) {
      return extractDir;
    }
    
    // Check for bundle subdirectory
    final bundleDir = Directory('${extractDir.path}/bundle');
    if (await bundleDir.exists() && await File('${bundleDir.path}/heroic_lsfg_applier').exists()) {
      return bundleDir;
    }
    
    // Search for executable in subdirectories
    await for (final entity in extractDir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('/heroic_lsfg_applier')) {
        return entity.parent;
      }
    }
    
    return null;
  }
  
  /// Copy directory recursively
  Future<void> _copyDirectory(Directory source, Directory destination) async {
    await for (final entity in source.list()) {
      final newPath = '${destination.path}/${entity.uri.pathSegments.last}';
      
      if (entity is File) {
        await entity.copy(newPath);
      } else if (entity is Directory) {
        final newDir = Directory(newPath);
        await newDir.create();
        await _copyDirectory(entity, newDir);
      }
    }
  }
  
  /// Normalize version string (remove 'v' prefix)
  String _normalizeVersion(String version) {
    return version.toLowerCase().replaceFirst('v', '').trim();
  }
  
  /// Compare versions, return true if version1 > version2
  bool _isNewerVersion(String version1, String version2) {
    final parts1 = version1.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    final parts2 = version2.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    
    // Pad to equal length
    while (parts1.length < 3) {
      parts1.add(0);
    }
    while (parts2.length < 3) {
      parts2.add(0);
    }
    
    for (int i = 0; i < 3; i++) {
      if (parts1[i] > parts2[i]) return true;
      if (parts1[i] < parts2[i]) return false;
    }
    
    return false;
  }
  
  /// Restart the application
  Future<void> restartApp() async {
    _log.log('[Update] Restarting application...');
    
    final execPath = Platform.resolvedExecutable;
    
    // Launch new instance
    await Process.start(execPath, [], mode: ProcessStartMode.detached);
    
    // Exit current instance
    exit(0);
  }
}
