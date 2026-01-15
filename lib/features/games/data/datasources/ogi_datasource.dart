import 'dart:convert';
import 'dart:io';
import '../../../../core/platform/platform_service.dart';
import '../../domain/entities/game_entity.dart';

import 'package:heroic_lsfg_applier/core/logging/logger_service.dart';

class OgiDatasource {
  final PlatformService _platformService;

  OgiDatasource(this._platformService);

  Future<List<Game>> getOgiGames() async {
    final libraryPath = _platformService.ogiLibraryPath;
    final dir = Directory(libraryPath);
    
    if (!dir.existsSync()) {
      return [];
    }

    final List<Game> games = [];
    
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
              
              // Note: hasLsfgEnabled can't be determined from OGI json alone.
              // It requires checking Steam shortcuts.
              // For now set to false, Repository can update it.
              
              games.add(Game(
                id: 'ogi:$appName',
                internalId: appName,
                title: title,
                type: GameType.ogi,
                hasLsfgEnabled: false,
                iconPath: iconUrl, // Using URL as path for now, UI should handle cached net images?
              ));
            }
          } catch (e) {
            // Skip malformed files
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
}
