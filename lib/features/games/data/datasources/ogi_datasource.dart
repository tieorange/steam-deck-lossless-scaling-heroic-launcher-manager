import 'dart:convert';
import 'dart:io';

import 'package:heroic_lsfg_applier/core/logging/logger_service.dart';
import 'package:heroic_lsfg_applier/core/platform/platform_service.dart';
import 'package:heroic_lsfg_applier/core/services/vdf_binary_service.dart';
import 'package:heroic_lsfg_applier/features/games/domain/entities/game_entity.dart';
import 'package:path/path.dart' as p;

class OgiDatasource {
  final PlatformService _platformService;
  final _vdfService = VdfBinaryService();

  OgiDatasource(this._platformService);

  Future<List<Game>> getOgiGames() async {
    final libraryPath = _platformService.ogiLibraryPath;
    final dir = Directory(libraryPath);
    
    if (!dir.existsSync()) {
      return [];
    }

    final List<Game> games = [];
    
    // Pre-scan shortcuts to Determine LSFG status
    final shortcutsStatus = await _getShortcutsLsfgStatus();
    
    try {
      final List<FileSystemEntity> entities = await dir.list().toList();
      
      for (final entity in entities) {
        if (entity is File && entity.path.endsWith('.json')) {
          try {
            final content = await entity.readAsString();
            final json = jsonDecode(content) as Map<String, dynamic>;
            
            if (json.containsKey('name') && json.containsKey('appID')) {
              final title = json['name'] as String;
              final appName = json['appID'].toString();
              final iconUrl = json['titleImage'] as String?;
              
              final isEnabled = shortcutsStatus[title] ?? false;
              
              games.add(Game(
                id: 'ogi:$appName',
                internalId: appName,
                title: title,
                type: GameType.ogi,
                hasLsfgEnabled: isEnabled,
                iconPath: iconUrl,
              ));
            }
          } catch (e) {
            LoggerService.instance.log('Error parsing OGI file ${entity.path}: $e');
          }
        }
      }
    } catch (e) {
      LoggerService.instance.log('Error listing OGI directory: $e');
      throw Exception('Failed to read OGI library: $e');
    }
    
    return games;
  }

  Future<void> applyLsfgToOgiGame(String appName, String title, bool enable) async {
    final shortcutFiles = await _findShortcutsFiles();
    bool found = false;
    
    for (final file in shortcutFiles) {
      try {
        final bytes = await file.readAsBytes();
        if (bytes.isEmpty) continue;

        final Map<String, dynamic> vdf = _vdfService.decode(bytes);
        bool modified = false;

        // VDF Structure: Root -> 'shortcuts' -> Map<String index, Map game>
        if (vdf.containsKey('shortcuts') && vdf['shortcuts'] is Map) {
          final shortcuts = vdf['shortcuts'] as Map;
          
          for (final key in shortcuts.keys) {
            final gameData = shortcuts[key];
            if (gameData is Map) {
              final name = gameData['AppName'] as String?;
              // Match by Title
              if (name == title) {
                found = true;
                final existingOpts = gameData['LaunchOptions'] as String? ?? '';
                final hasLsfg = existingOpts.contains(PlatformService.lsfgEnvKey);
                
                String newOpts = existingOpts;
                
                if (enable && !hasLsfg) {
                  // Build environment variable prefix
                  final env = '${PlatformService.lsfgEnvKey}=${PlatformService.lsfgEnvValue}';
                  
                  // Steam Launch Options syntax: VAR=VAL %command% [additional args]
                  // Check if user already has %command% in their options
                  if (existingOpts.contains('%command%')) {
                    // Prepend env var before existing options (which include %command%)
                    newOpts = '$env $existingOpts';
                  } else {
                    // No %command% present, add full syntax
                    newOpts = existingOpts.isEmpty 
                        ? '$env %command%'
                        : '$env %command% $existingOpts';
                  }
                  modified = true;
                } else if (!enable && hasLsfg) {
                   // Remove ENV
                   final env = '${PlatformService.lsfgEnvKey}=${PlatformService.lsfgEnvValue}';
                   newOpts = newOpts.replaceAll(env, '').replaceAll('  ', ' ').trim();
                   // Clean up if we added %command% solely for this? Hard to know user intent.
                   // Leave %command% if it remains, worst case it's harmless.
                   modified = true;
                }
                
                if (modified) {
                   gameData['LaunchOptions'] = newOpts;
                   LoggerService.instance.log('[OGI] Modified launch options for $title: $newOpts');
                }
              }
            }
          }
        }

        if (modified) {
          // Backup
          final backupPath = '${file.path}.bak';
          await file.copy(backupPath);
          LoggerService.instance.log('[OGI] Created backup: $backupPath');
          
          // Write
          final newBytes = _vdfService.encode(vdf);
          await file.writeAsBytes(newBytes);
          LoggerService.instance.log('[OGI] Saved updated shortcuts.vdf');
        }

      } catch (e) {
        LoggerService.instance.log('Error processing shortcuts.vdf at ${file.path}: $e');
      }
    }
    
    if (!found) {
      LoggerService.instance.log('Warning: Game "$title" not found in any Steam shortcuts.vdf');
      // Maybe throw to inform user to "Add to Steam" in OGI first?
    }
  }

  /// Returns a map of game title to LSFG enabled status.
  Future<Map<String, bool>> _getShortcutsLsfgStatus() async {
    final statusMap = <String, bool>{};
    final files = await _findShortcutsFiles();
    
    for (final file in files) {
      try {
        final bytes = await file.readAsBytes();
        if (bytes.isEmpty) continue;
        
        final vdf = _vdfService.decode(bytes);
        if (vdf.containsKey('shortcuts') && vdf['shortcuts'] is Map) {
           final shortcuts = vdf['shortcuts'] as Map;
           for (final gameData in shortcuts.values) {
              if (gameData is Map) {
                final name = gameData['AppName'] as String?;
                final opts = gameData['LaunchOptions'] as String? ?? '';
                if (name != null) {
                  statusMap[name] = opts.contains(PlatformService.lsfgEnvKey);
                }
              }
           }
        }
      } catch (e) {
         LoggerService.instance.log('Error reading VDF status: $e');
      }
    }
    return statusMap;
  }

  Future<List<File>> _findShortcutsFiles() async {
    final userDataPath = _platformService.steamUserDataPath;
    final dir = Directory(userDataPath);
    if (!dir.existsSync()) return [];
    
    final results = <File>[];
    try {
      final users = await dir.list().toList();
      for (final userDir in users) {
         if (userDir is Directory) {
            // Check config/shortcuts.vdf
            final vdfPath = p.join(userDir.path, 'config', 'shortcuts.vdf');
            final vdfFile = File(vdfPath);
            if (vdfFile.existsSync()) {
               results.add(vdfFile);
            }
         }
      }
    } catch (e) {
       LoggerService.instance.log('Error finding steam users: $e');
    }
    return results;
  }
}
