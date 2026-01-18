// ignore_for_file: avoid_print
import 'dart:io';
import 'package:heroic_lsfg_applier/core/services/vdf_binary_service.dart';

void main() async {
  print('Setting up macOS Test Environment...');

  final home = Platform.environment['HOME'];
  final baseDir = '$home/HeroicTest';

  // 1. Create Directories
  print('Creating directories...');
  final ogiDir = Directory('$baseDir/OpenGameInstaller/library');
  final steamDir = Directory('$baseDir/Steam/userdata/TestUser/config');

  await ogiDir.create(recursive: true);
  await steamDir.create(recursive: true);

  // 2. Create OGI Game JSON
  print('Creating OGI game.json...');
  final ogiGameId = '999123';
  final ogiGameName = 'Test OGI Game';
  final ogiJson =
      '''
  {
    "name": "$ogiGameName",
    "appID": $ogiGameId,
    "titleImage": "https://example.com/icon.png",
    "exe": "/path/to/game.exe"
  }
  ''';
  await File('${ogiDir.path}/$ogiGameId.json').writeAsString(ogiJson);

  // 3. Create shortcuts.vdf with VdfBinaryService
  print('Creating shortcuts.vdf...');
  final vdfService = VdfBinaryService();

  // Shortcuts VDF Structure:
  // Root -> shortcuts -> "0" -> { AppName, Exe, LaunchOptions, ... }
  final shortcutsData = {
    'shortcuts': {
      '0': {
        'AppName': ogiGameName,
        'Exe': '/path/to/game.exe',
        'StartDir': '/path/to/',
        'icon': '',
        'LaunchOptions': '', // Empty initially
        'IsHidden': 0,
        'AllowDesktopConfig': 1,
        'AllowOverlay': 1,
        'OpenVR': 0,
        'Devkit': 0,
        'DevkitGameID': '',
        'LastPlayTime': 0,
        'tags': {},
      },
      '1': {
        'AppName': 'Another Game',
        'Exe': '/path/to/other.exe',
        'LaunchOptions': 'EXISTING_VAR=1',
      },
    },
  };

  try {
    final bytes = vdfService.encode(shortcutsData);
    await File('${steamDir.path}/shortcuts.vdf').writeAsBytes(bytes);
    print('Successfully created shortcuts.vdf (${bytes.length} bytes)');

    // Verify by decoding back
    final decoded = vdfService.decode(bytes);
    print('Verification Decode: Found ${(decoded['shortcuts'] as Map).length} shortcuts');
  } catch (e) {
    print('Error generating VDF: $e');
    exit(1);
  }

  print('Test environment setup complete!');
  print('OGI Path: ${ogiDir.path}');
  print('Steam Path: ${steamDir.path}');
}
