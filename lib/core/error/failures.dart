import 'package:dartz/dartz.dart';

/// Base failure class for error handling
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

/// File system related errors (read/write/access)
class FileSystemFailure extends Failure {
  const FileSystemFailure(super.message);
}

/// JSON parsing or serialization errors
class JsonParseFailure extends Failure {
  const JsonParseFailure(super.message);
}

/// Heroic Games Launcher config directory not found
class HeroicNotFoundFailure extends Failure {
  const HeroicNotFoundFailure()
    : super('Heroic Games Launcher configuration not found. Please ensure Heroic is installed.');
}

/// No games found in Heroic config
class NoGamesFoundFailure extends Failure {
  const NoGamesFoundFailure() : super('No games found in Heroic Games Launcher.');
}

/// Game not found in Steam shortcuts (OGI specific)
class GameNotInSteamFailure extends Failure {
  final String title;
  const GameNotInSteamFailure(this.title)
    : super(
        'Game "$title" not found in Steam shortcuts. Please add it to Steam via OpenGameInstaller.',
      );
}

/// Backup related errors
class BackupFailure extends Failure {
  const BackupFailure(super.message);
}

/// Cache/Settings related errors
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Type alias for Result
typedef Result<T> = Either<Failure, T>;
