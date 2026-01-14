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
  const HeroicNotFoundFailure() : super('Heroic Games Launcher configuration not found. Please ensure Heroic is installed.');
}

/// No games found in Heroic config
class NoGamesFoundFailure extends Failure {
  const NoGamesFoundFailure() : super('No games found in Heroic Games Launcher.');
}

/// Backup related errors
class BackupFailure extends Failure {
  const BackupFailure(super.message);
}

/// Type alias for Either with Failure
typedef Result<T> = Either<Failure, T>;
