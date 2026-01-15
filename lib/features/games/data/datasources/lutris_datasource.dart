import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;
import '../../../../core/platform/platform_service.dart';
import '../../domain/entities/game_entity.dart';

class LutrisDatasource {
  final PlatformService _platformService;

  LutrisDatasource(this._platformService);

  Future<List<Game>> getLutrisGames() async {
    final configPath = _platformService.lutrisConfigPath;
    final dir = Directory(configPath);
    
    if (!dir.existsSync()) {
      return [];
    }
    
    final games = <Game>[];
    
    try {
      final entities = await dir.list().toList();
      for (final entity in entities) {
        if (entity is File && entity.path.endsWith('.yml')) {
          try {
            final content = await entity.readAsString();
            final yaml = loadYaml(content);
            
            // Allow YamlMap or Map
            if (yaml is Map && yaml.containsKey('name')) {
               final name = yaml['name']?.toString() ?? 'Unknown';
               
               // game_slug is safer than filename, but fallback to filename 
               final slug = yaml['game_slug']?.toString() ?? p.basenameWithoutExtension(entity.path);
               
               bool hasLsfg = false;
               // Check system -> env
               if (yaml['system'] is Map) {
                 final system = yaml['system'] as Map;
                 if (system['env'] is Map) {
                   final env = system['env'] as Map;
                   if (env.containsKey(PlatformService.lsfgEnvKey)) {
                     hasLsfg = env[PlatformService.lsfgEnvKey].toString() == PlatformService.lsfgEnvValue;
                   }
                 }
               }
               
               games.add(Game(
                  id: 'lutris:$slug',
                  internalId: slug,
                  title: name,
                  type: GameType.lutris,
                  hasLsfgEnabled: hasLsfg,
                  iconPath: null,
               ));
            }
          } catch (e) {
            // Skip malformed
            print('Error parsing lutris file ${entity.path}: $e');
          }
        }
      }
    } catch (e) {
      print('Error listing Lutris games: $e');
    }
    return games;
  }
}
