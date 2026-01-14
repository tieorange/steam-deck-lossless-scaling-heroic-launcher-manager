import 'package:dartz/dartz.dart';
import 'package:heroic_lsfg_applier/core/error/failures.dart';
import 'package:heroic_lsfg_applier/features/games/domain/entities/game_entity.dart';

/// Repository interface for game operations
abstract class GameRepository {
  /// Get all games from Heroic config
  Future<Result<List<Game>>> getGames();
  
  /// Apply LSFG environment variable to specified games
  Future<Result<Unit>> applyLsfgToGames(List<String> appNames);
  
  /// Remove LSFG environment variable from specified games
  Future<Result<Unit>> removeLsfgFromGames(List<String> appNames);
}
