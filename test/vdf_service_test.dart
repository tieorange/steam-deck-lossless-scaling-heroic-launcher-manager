import 'package:flutter_test/flutter_test.dart';
import 'package:heroic_lsfg_applier/core/services/vdf_binary_service.dart';
import 'package:heroic_lsfg_applier/core/error/exceptions.dart';

void main() {
  group('VdfBinaryService', () {
    final service = VdfBinaryService();

    test('should encode and decode Int64 correctly', () {
      final input = {'steamid': 76561198000000000}; // > 32-bit int
      final encoded = service.encode(input);
      final decoded = service.decode(encoded);

      expect(decoded['steamid'], equals(76561198000000000));
    });

    test('should handle nested maps', () {
      final input = {
        'shortcuts': {
          '0': {'AppName': 'Test Game', 'appid': 12345},
        },
      };
      final encoded = service.encode(input);
      final decoded = service.decode(encoded);

      expect(decoded['shortcuts']['0']['AppName'], equals('Test Game'));
    });
  });

  group('Exceptions', () {
    test('GameNotInSteamException should have correct message', () {
      const exception = GameNotInSteamException('My Game');
      expect(exception.toString(), contains('Game "My Game" not found in Steam shortcuts'));
    });
  });
}
