import 'package:dartz/dartz.dart';
import 'package:heroic_lsfg_applier/core/error/failures.dart';
import 'package:heroic_lsfg_applier/core/logging/logger_service.dart';
import 'package:heroic_lsfg_applier/features/games/domain/repositories/game_repository.dart';

/// Use case for removing LSFG environment variable from games.
class RemoveLsfgUseCase {
  final GameRepository _gameRepository;
  
  RemoveLsfgUseCase(this._gameRepository);
  
  /// Removes LSFG from the specified games.
  Future<Result<Unit>> call(List<String> gameIds) async {
    LoggerService.instance.log('[RemoveLsfgUseCase] Removing LSFG from ${gameIds.length} games');
    
    final result = await _gameRepository.removeLsfgFromGames(gameIds);
    
    result.fold(
      (failure) => LoggerService.instance.log('[RemoveLsfgUseCase] Remove failed: ${failure.message}'),
      (_) => LoggerService.instance.log('[RemoveLsfgUseCase] Remove succeeded'),
    );
    
    return result;
  }
}
