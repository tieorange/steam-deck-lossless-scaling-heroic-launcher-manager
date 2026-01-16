import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
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
import 'package:heroic_lsfg_applier/core/logging/logger_service.dart';

/// Implementation of GameRepository using local file system
class GameRepositoryImpl implements GameRepository {
  final PlatformService _platformService;
  late final OgiDatasource _ogiDatasource;
  
  GameRepositoryImpl(this._platformService) {
    _ogiDatasource = OgiDatasource(_platformService);
  }
  
  @override
  Future<Result<List<Game>>> getGames() async {
    try {
      LoggerService.instance.log('[GameRepository] getGames called');
      final games = <Game>[];
      bool anySourceFound = false;

      // 1. Fetch Heroic Games
      try {
        LoggerService.instance.log('[GameRepository] Checking Heroic config: ${_platformService.gameConfigPath}');
        final gameConfigDir = Directory(_platformService.gameConfigPath);
        
        if (await gameConfigDir.exists()) {
          anySourceFound = true;
          LoggerService.instance.log('[GameRepository] Heroic directory exists, listing files...');
          
          await for (final entity in gameConfigDir.list()) {
            if (entity is File && entity.path.endsWith('.json')) {
              final game = await _parseGameFile(entity);
              if (game != null) {
                games.add(game);
              }
            }
          }
        } else {
          LoggerService.instance.log('[GameRepository] Heroic config directory does not exist');
        }
      } catch (e) {
        LoggerService.instance.log('[GameRepository] Error loading Heroic games: $e');
      }

      // 2. Fetch OGI Games
      try {
        LoggerService.instance.log('[GameRepository] Checking OGI library: ${_platformService.ogiLibraryPath}');
        final ogiGames = await _ogiDatasource.getOgiGames();
        if (ogiGames.isNotEmpty) {
          anySourceFound = true;
          games.addAll(ogiGames);
          LoggerService.instance.log('[GameRepository] Added ${ogiGames.length} OGI games');
        } else {
           LoggerService.instance.log('[GameRepository] No OGI games found');
        }
      } catch (e) {
        LoggerService.instance.log('[GameRepository] Error loading OGI games: $e');
      }

      // 3. Fetch Lutris Games
      try {
        LoggerService.instance.log('[GameRepository] Checking Lutris config: ${_platformService.lutrisConfigPath}');
        final lutrisDatasource = LutrisDatasource(_platformService);
        final lutrisGames = await lutrisDatasource.getLutrisGames();
        if (lutrisGames.isNotEmpty) {
          anySourceFound = true;
          games.addAll(lutrisGames);
          LoggerService.instance.log('[GameRepository] Added ${lutrisGames.length} Lutris games');
        } else {
           LoggerService.instance.log('[GameRepository] No Lutris games found');
        }
      } catch (e) {
        LoggerService.instance.log('[GameRepository] Error loading Lutris games: $e');
      }
      
      LoggerService.instance.log('[GameRepository] Total games parsed: ${games.length}');
      
      if (!anySourceFound && games.isEmpty) {
        LoggerService.instance.log('[GameRepository] No game sources found');
        return const Left(NoGamesFoundFailure());
      }
      
      // Sort alphabetically by title
      games.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      
      return Right(games);
    } catch (e, stackTrace) {
      LoggerService.instance.log('[GameRepository] Error reading games: $e');
      LoggerService.instance.log('[GameRepository] Stack trace: $stackTrace');
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
      LoggerService.instance.log('[GameRepository] applyLsfgToGames called for: $appNames');
      for (final appName in appNames) {
        LoggerService.instance.log('[GameRepository] Modifying config for: $appName');
        await _modifyGameConfig(appName, addLsfg: true);
      }
      LoggerService.instance.log('[GameRepository] Successfully applied LSFG to all games');
      return const Right(unit);
    } catch (e, stackTrace) {
      LoggerService.instance.log('[GameRepository] Failed to apply LSFG: $e');
      LoggerService.instance.log('[GameRepository] Stack trace: $stackTrace');
      return Left(FileSystemFailure('Failed to apply LSFG: $e'));
    }
  }
  
  @override
  Future<Result<Unit>> removeLsfgFromGames(List<String> appNames) async {
    try {
      LoggerService.instance.log('[GameRepository] removeLsfgFromGames called for: $appNames');
      for (final appName in appNames) {
        LoggerService.instance.log('[GameRepository] Modifying config for: $appName');
        await _modifyGameConfig(appName, addLsfg: false);
      }
      LoggerService.instance.log('[GameRepository] Successfully removed LSFG from all games');
      return const Right(unit);
    } catch (e, stackTrace) {
      LoggerService.instance.log('[GameRepository] Failed to remove LSFG: $e');
      LoggerService.instance.log('[GameRepository] Stack trace: $stackTrace');
      return Left(FileSystemFailure('Failed to remove LSFG: $e'));
    }
  }
  
  Future<void> _modifyGameConfig(String id, {required bool addLsfg}) async {
    final parts = id.split(':');
    if (parts.length < 2) {
       LoggerService.instance.log('Invalid Game ID format: $id. Assuming legacy/Heroic.');
       await _modifyHeroicConfig(id, addLsfg: addLsfg);
       return;
    }
    
    final source = parts[0];
    final appName = parts.sublist(1).join(':'); // handle colons in name

    LoggerService.instance.log('[GameRepository] _modifyGameConfig: src=$source, app=$appName (addLsfg: $addLsfg)');

    if (source == 'heroic') {
       await _modifyHeroicConfig(appName, addLsfg: addLsfg);
    } else if (source == 'ogi') {
       // We need to look up the Title!
       LoggerService.instance.log('[GameRepository] Modifying OGI game: $appName');
       final ogiGames = await _ogiDatasource.getOgiGames();
       try {
         final game = ogiGames.firstWhere((g) => g.internalId == appName);
         await _ogiDatasource.applyLsfgToOgiGame(appName, game.title, addLsfg);
       } catch (e) {
          LoggerService.instance.log('[GameRepository] Failed to find OGI game details for id: $appName. Error: $e');
          throw Exception('Game not found in OGI library: $appName');
       }
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
         LoggerService.instance.log('[GameRepository] Modifying Lutris config: $lutrisFilePath');
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
           LoggerService.instance.log('[GameRepository] Failed to update Lutris config: $e');
           throw Exception('Failed to update Lutris config: $e');
         }
      }
      throw Exception('Lutris config file not found: $appName');
  }
}
