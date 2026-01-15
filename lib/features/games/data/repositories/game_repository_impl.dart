import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:heroic_lsfg_applier/core/error/failures.dart';
import 'package:heroic_lsfg_applier/core/platform/platform_service.dart';
import 'package:heroic_lsfg_applier/features/games/data/models/game_config_model.dart';
import 'package:heroic_lsfg_applier/features/games/domain/entities/game_entity.dart';
import 'package:heroic_lsfg_applier/features/games/domain/repositories/game_repository.dart';
import 'package:heroic_lsfg_applier/features/games/data/datasources/ogi_datasource.dart';
import 'package:heroic_lsfg_applier/features/games/data/datasources/lutris_datasource.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

/// Implementation of GameRepository using local file system
class GameRepositoryImpl implements GameRepository {
  final PlatformService _platformService;
  
  GameRepositoryImpl(this._platformService);
  
  @override
  Future<Result<List<Game>>> getGames() async {
    try {
      debugPrint('[GameRepository] getGames called');
      final games = <Game>[];
      bool anySourceFound = false;

      // 1. Fetch Heroic Games
      try {
        debugPrint('[GameRepository] Checking Heroic config: ${_platformService.gameConfigPath}');
        final gameConfigDir = Directory(_platformService.gameConfigPath);
        
        if (await gameConfigDir.exists()) {
          anySourceFound = true;
          debugPrint('[GameRepository] Heroic directory exists, listing files...');
          
          await for (final entity in gameConfigDir.list()) {
            if (entity is File && entity.path.endsWith('.json')) {
              final game = await _parseGameFile(entity);
              if (game != null) {
                games.add(game);
              }
            }
          }
        } else {
          debugPrint('[GameRepository] Heroic config directory does not exist');
        }
      } catch (e) {
        debugPrint('[GameRepository] Error loading Heroic games: $e');
      }

      // 2. Fetch OGI Games
      try {
        debugPrint('[GameRepository] Checking OGI library: ${_platformService.ogiLibraryPath}');
        final ogiDatasource = OgiDatasource(_platformService);
        final ogiGames = await ogiDatasource.getOgiGames();
        if (ogiGames.isNotEmpty) {
          anySourceFound = true;
          games.addAll(ogiGames);
          debugPrint('[GameRepository] Added ${ogiGames.length} OGI games');
        } else {
           debugPrint('[GameRepository] No OGI games found');
        }
      } catch (e) {
        debugPrint('[GameRepository] Error loading OGI games: $e');
      }

      // 3. Fetch Lutris Games
      try {
        debugPrint('[GameRepository] Checking Lutris config: ${_platformService.lutrisConfigPath}');
        final lutrisDatasource = LutrisDatasource(_platformService);
        final lutrisGames = await lutrisDatasource.getLutrisGames();
        if (lutrisGames.isNotEmpty) {
          anySourceFound = true;
          games.addAll(lutrisGames);
          debugPrint('[GameRepository] Added ${lutrisGames.length} Lutris games');
        } else {
           debugPrint('[GameRepository] No Lutris games found');
        }
      } catch (e) {
        debugPrint('[GameRepository] Error loading Lutris games: $e');
      }
      
      debugPrint('[GameRepository] Total games parsed: ${games.length}');
      
      if (!anySourceFound && games.isEmpty) {
        debugPrint('[GameRepository] No game sources found');
        return const Left(NoGamesFoundFailure());
      }
      
      // Sort alphabetically by title
      games.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      
      return Right(games);
    } catch (e, stackTrace) {
      debugPrint('[GameRepository] Error reading games: $e');
      debugPrint('[GameRepository] Stack trace: $stackTrace');
      return Left(FileSystemFailure('Failed to read games: $e'));
    }
  }
  
  Future<Game?> _parseGameFile(File file) async {
    try {
      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;
      final model = GameConfigModel.fromJson(json);
      
      // Skip files without proper identification
      if (model.appName == null && model.title == null) {
        return null;
      }
      
      final appName = model.appName ?? p.basenameWithoutExtension(file.path);
      
      // Try to find icon
      String? iconPath = _findIcon(appName);
      
      return Game(
        id: 'heroic:$appName',
        internalId: appName,
        title: model.displayTitle,
        iconPath: iconPath,
        hasLsfgEnabled: model.hasLsfgEnabled,
      );
    } catch (e) {
      // Skip malformed files
      return null;
    }
  }
  
  String? _findIcon(String appName) {
    final iconDir = Directory(_platformService.iconCachePath);
    if (!iconDir.existsSync()) return null;
    
    // Try common icon locations and formats
    final possiblePaths = [
      '${iconDir.path}/$appName.jpg',
      '${iconDir.path}/$appName.png',
      '${iconDir.path}/$appName.webp',
      '${iconDir.path}/images/$appName.jpg',
      '${iconDir.path}/images/$appName.png',
    ];
    
    for (final path in possiblePaths) {
      if (File(path).existsSync()) {
        return path;
      }
    }
    
    return null;
  }
  
  @override
  Future<Result<Unit>> applyLsfgToGames(List<String> appNames) async {
    try {
      debugPrint('[GameRepository] applyLsfgToGames called for: $appNames');
      for (final appName in appNames) {
        debugPrint('[GameRepository] Modifying config for: $appName');
        await _modifyGameConfig(appName, addLsfg: true);
      }
      debugPrint('[GameRepository] Successfully applied LSFG to all games');
      return const Right(unit);
    } catch (e, stackTrace) {
      debugPrint('[GameRepository] Failed to apply LSFG: $e');
      debugPrint('[GameRepository] Stack trace: $stackTrace');
      return Left(FileSystemFailure('Failed to apply LSFG: $e'));
    }
  }
  
  @override
  Future<Result<Unit>> removeLsfgFromGames(List<String> appNames) async {
    try {
      debugPrint('[GameRepository] removeLsfgFromGames called for: $appNames');
      for (final appName in appNames) {
        debugPrint('[GameRepository] Modifying config for: $appName');
        await _modifyGameConfig(appName, addLsfg: false);
      }
      debugPrint('[GameRepository] Successfully removed LSFG from all games');
      return const Right(unit);
    } catch (e, stackTrace) {
      debugPrint('[GameRepository] Failed to remove LSFG: $e');
      debugPrint('[GameRepository] Stack trace: $stackTrace');
      return Left(FileSystemFailure('Failed to remove LSFG: $e'));
    }
  }
  
  Future<void> _modifyGameConfig(String id, {required bool addLsfg}) async {
    final parts = id.split(':');
    if (parts.length < 2) {
       // Check if it's a legacy ID (probably Heroic if no prefix)
       // Or throw. Assuming new format is enforced.
       debugPrint('Invalid Game ID format: $id. Assuming legacy/Heroic.');
       // If legacy, assume Heroic path
       await _modifyHeroicConfig(id, addLsfg: addLsfg);
       return;
    }
    
    final source = parts[0];
    final appName = parts.sublist(1).join(':'); // handle colons in name

    debugPrint('[GameRepository] _modifyGameConfig: src=$source, app=$appName (addLsfg: $addLsfg)');

    if (source == 'heroic') {
       await _modifyHeroicConfig(appName, addLsfg: addLsfg);
    } else if (source == 'ogi') {
       debugPrint('[GameRepository] Found OGI game, but shortcuts editing not implemented');
       throw Exception('LSFG Support for OpenGameInstaller games is not yet implemented (requires Steam Shortcuts editing).');
    } else if (source == 'lutris') {
       await _modifyLutrisConfig(appName, addLsfg: addLsfg);
    } else {
       throw Exception('Unknown game source: $source');
    }
  }

  Future<void> _modifyHeroicConfig(String appName, {required bool addLsfg}) async {
      final heroicFilePath = '${_platformService.gameConfigPath}/$appName.json';
      final heroicFile = File(heroicFilePath);
      
      if (!await heroicFile.exists()) {
        throw Exception('Heroic config not found: $heroicFilePath');
      }

      final content = await heroicFile.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;
      
      String keyToUse = 'environmentOptions'; 
      if (json.containsKey('enviromentOptions')) {
         keyToUse = 'enviromentOptions';
      } else if (json.containsKey('environmentOptions')) {
         keyToUse = 'environmentOptions';
      }
      
      Map<String, dynamic> envOptions = {};
      if (json.containsKey(keyToUse)) {
        envOptions = Map<String, dynamic>.from(json[keyToUse] as Map);
      }
      
      if (addLsfg) {
        envOptions[PlatformService.lsfgEnvKey] = PlatformService.lsfgEnvValue;
      } else {
        envOptions.remove(PlatformService.lsfgEnvKey);
      }
      
      json[keyToUse] = envOptions;
      
      final encoder = const JsonEncoder.withIndent('  ');
      await heroicFile.writeAsString(encoder.convert(json));
  }

  Future<void> _modifyLutrisConfig(String appName, {required bool addLsfg}) async {
      final lutrisFilePath = '${_platformService.lutrisConfigPath}/$appName.yml';
      final lutrisFile = File(lutrisFilePath);
      
      if (await lutrisFile.exists()) {
         debugPrint('[GameRepository] Modifying Lutris config: $lutrisFilePath');
         try {
           final content = await lutrisFile.readAsString();
           final doc = YamlEditor(content);
           final yaml = loadYaml(content);
           
           if (yaml is Map) {
             if (!yaml.containsKey('system') || yaml['system'] == null) {
                doc.update(['system'], {'env': {}});
             } else {
               final system = yaml['system'];
               if (system is Map && (!system.containsKey('env') || system['env'] == null)) {
                  doc.update(['system', 'env'], {});
               }
             }
           }

           if (addLsfg) {
              doc.update(['system', 'env', PlatformService.lsfgEnvKey], PlatformService.lsfgEnvValue);
           } else {
              doc.remove(['system', 'env', PlatformService.lsfgEnvKey]);
           }
           
           await lutrisFile.writeAsString(doc.toString());
           return;
         } catch (e) {
           debugPrint('[GameRepository] Failed to update Lutris config: $e');
           throw Exception('Failed to update Lutris config: $e');
         }
      }
      throw Exception('Lutris config file not found: $appName');
  }
