// ignore_for_file: avoid_print
import 'dart:io';
import 'package:heroic_lsfg_applier/core/services/vdf_binary_service.dart';

void main() async {
  final home = Platform.environment['HOME'];
  final vdfPath = '$home/HeroicTest/Steam/userdata/TestUser/config/shortcuts.vdf';

  print('Verifying shortcuts.vdf at: $vdfPath');

  if (!File(vdfPath).existsSync()) {
    print('Error: File not found. Run scripts/setup_macos_test.dart first.');
    return;
  }

  try {
    final bytes = await File(vdfPath).readAsBytes();
    final vdfService = VdfBinaryService();
    final data = vdfService.decode(bytes);

    if (data.containsKey('shortcuts') && data['shortcuts'] is Map) {
      final shortcuts = data['shortcuts'] as Map;
      print('\nFound ${shortcuts.length} shortcuts:');

      for (final key in shortcuts.keys) {
        final game = shortcuts[key] as Map;
        final name = game['AppName'];
        final opts = game['LaunchOptions'];

        print('------------------------------------------------');
        print('Game: $name');
        print('LaunchOptions: "$opts"');

        if (opts.toString().contains('LSFG_PROCESS=decky-lsfg-vk')) {
          print('✅ LSFG Environment Variable FOUND');
        } else {
          print('❌ LSFG Environment Variable NOT FOUND');
        }
      }
      print('------------------------------------------------');
    }
  } catch (e) {
    print('Error decoding VDF: $e');
  }
}
