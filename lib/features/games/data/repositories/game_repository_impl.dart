import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:heroic_lsfg_applier/core/error/failures.dart';
import 'package:heroic_lsfg_applier/core/platform/platform_service.dart';
import 'package:heroic_lsfg_applier/features/games/data/models/game_config_model.dart';
import 'package:heroic_lsfg_applier/features/games/domain/entities/game_entity.dart';
import 'package:heroic_lsfg_applier/features/games/domain/repositories/game_repository.dart';
import 'package:path/path.dart' as p;

/// Implementation of GameRepository using local file system
class GameRepositoryImpl implements GameRepository {
  final PlatformService _platformService;
  
  GameRepositoryImpl(this._platformService);
  
  @override
  Future<Result<List<Game>>> getGames() async {
    try {
      debugPrint('[GameRepository] getGames called');
      debugPrint('[GameRepository] gameConfigPath: ${_platformService.gameConfigPath}');
      
      final gameConfigDir = Directory(_platformService.gameConfigPath);
      
      if (!await gameConfigDir.exists()) {
        debugPrint('[GameRepository] Game config directory does not exist!');
        return const Left(HeroicNotFoundFailure());
      }
      
      debugPrint('[GameRepository] Directory exists, listing files...');
      final games = <Game>[];
      
      await for (final entity in gameConfigDir.list()) {
        debugPrint('[GameRepository] Found entity: ${entity.path}');
        if (entity is File && entity.path.endsWith('.json')) {
          final game = await _parseGameFile(entity);
          if (game != null) {
            games.add(game);
          }
        }
      }
      
      debugPrint('[GameRepository] Parsed ${games.length} games');
      
      if (games.isEmpty) {
        debugPrint('[GameRepository] No games found');
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
        appName: appName,
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
  
  Future<void> _modifyGameConfig(String appName, {required bool addLsfg}) async {
    final filePath = '${_platformService.gameConfigPath}/$appName.json';
    debugPrint('[GameRepository] _modifyGameConfig: $filePath (addLsfg: $addLsfg)');
    final file = File(filePath);
    
    if (!await file.exists()) {
      debugPrint('[GameRepository] Game config file not found: $filePath');
      throw Exception('Game config file not found: $filePath');
    }
    
    final content = await file.readAsString();
    final json = jsonDecode(content) as Map<String, dynamic>;
    
    // Handle the environment variable
    // Heroic uses both 'environment' and 'enviromentOptions' (with typo)
    // We'll use 'enviromentOptions' to match Heroic's format
    Map<String, dynamic> envOptions = {};
    if (json.containsKey('enviromentOptions')) {
      envOptions = Map<String, dynamic>.from(json['enviromentOptions'] as Map);
    }
    
    if (addLsfg) {
      envOptions[PlatformService.lsfgEnvKey] = PlatformService.lsfgEnvValue;
    } else {
      envOptions.remove(PlatformService.lsfgEnvKey);
    }
    
    json['enviromentOptions'] = envOptions;
    
    // Write back with nice formatting
    final encoder = const JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(json));
  }
}
