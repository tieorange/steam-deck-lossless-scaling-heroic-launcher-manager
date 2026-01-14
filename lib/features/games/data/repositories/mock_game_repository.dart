import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:heroic_lsfg_applier/core/error/failures.dart';
import 'package:heroic_lsfg_applier/features/games/domain/entities/game_entity.dart';
import 'package:heroic_lsfg_applier/features/games/domain/repositories/game_repository.dart';

/// Mock repository for testing on macOS without real Heroic installation
class MockGameRepository implements GameRepository {
  final List<Game> _mockGames = [
    const Game(
      appName: 'cyberpunk2077',
      title: 'Cyberpunk 2077',
      iconPath: null,
      hasLsfgEnabled: false,
    ),
    const Game(
      appName: 'elden_ring',
      title: 'Elden Ring',
      iconPath: null,
      hasLsfgEnabled: false,
    ),
    const Game(
      appName: 'witcher3',
      title: 'The Witcher 3: Wild Hunt',
      iconPath: null,
      hasLsfgEnabled: true,
    ),
    const Game(
      appName: 'baldurs_gate_3',
      title: "Baldur's Gate 3",
      iconPath: null,
      hasLsfgEnabled: false,
    ),
    const Game(
      appName: 'hogwarts_legacy',
      title: 'Hogwarts Legacy',
      iconPath: null,
      hasLsfgEnabled: true,
    ),
    const Game(
      appName: 'starfield',
      title: 'Starfield',
      iconPath: null,
      hasLsfgEnabled: false,
    ),
    const Game(
      appName: 'red_dead_redemption_2',
      title: 'Red Dead Redemption 2',
      iconPath: null,
      hasLsfgEnabled: false,
    ),
    const Game(
      appName: 'horizon_zero_dawn',
      title: 'Horizon Zero Dawn',
      iconPath: null,
      hasLsfgEnabled: true,
    ),
    const Game(
      appName: 'death_stranding',
      title: 'Death Stranding',
      iconPath: null,
      hasLsfgEnabled: false,
    ),
    const Game(
      appName: 'god_of_war',
      title: 'God of War',
      iconPath: null,
      hasLsfgEnabled: false,
    ),
  ];
  
  // Track LSFG status in memory for mock
  final Map<String, bool> _lsfgStatus = {};
  
  MockGameRepository() {
    // Initialize from mock games
    for (final game in _mockGames) {
      _lsfgStatus[game.appName] = game.hasLsfgEnabled;
    }
  }
  
  @override
  Future<Result<List<Game>>> getGames() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final games = _mockGames.map((game) {
      return game.copyWith(
        hasLsfgEnabled: _lsfgStatus[game.appName] ?? game.hasLsfgEnabled,
      );
    }).toList();
    
    // Sort alphabetically
    games.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    
    return Right(games);
  }
  
  @override
  Future<Result<Unit>> applyLsfgToGames(List<String> appNames) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    for (final appName in appNames) {
      _lsfgStatus[appName] = true;
    }
    
    return const Right(unit);
  }
  
  @override
  Future<Result<Unit>> removeLsfgFromGames(List<String> appNames) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    for (final appName in appNames) {
      _lsfgStatus[appName] = false;
    }
    
    return const Right(unit);
  }
}

/// Check if we should use mock data (macOS without Heroic)
bool shouldUseMockRepository() {
  if (!Platform.isMacOS) return false;
  
  // Check if the mock directory exists
  final homeDir = Platform.environment['HOME'] ?? '/Users/user';
  final mockPath = '$homeDir/HeroicTest/config/heroic/GamesConfig';
  
  // Use mock if the test directory doesn't exist either
  return !Directory(mockPath).existsSync();
}
