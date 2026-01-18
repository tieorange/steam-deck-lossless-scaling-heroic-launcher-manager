class GameNotInSteamException implements Exception {
  final String gameTitle;
  const GameNotInSteamException(this.gameTitle);

  @override
  String toString() =>
      'Game "$gameTitle" not found in Steam shortcuts. Please add it to Steam via OpenGameInstaller.';
}
