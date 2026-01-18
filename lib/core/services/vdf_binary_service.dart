import 'dart:convert';
import 'dart:typed_data';

/// Service for encoding/decoding Steam's binary VDF (Valve Data Format) files.
///
/// ## Binary VDF Structure
///
/// Steam uses a binary format for files like `shortcuts.vdf`. The format is:
/// - **0x00** (`_typeMap`): Nested object - followed by null-terminated key, then contents, then 0x08
/// - **0x01** (`_typeString`): String value - followed by null-terminated key, then null-terminated value
/// - **0x02** (`_typeInt32`): 32-bit integer - followed by null-terminated key, then 4-byte little-endian int
/// - **0x08** (`_typeEnd`): End of current map/object
///
/// ## Example: shortcuts.vdf Structure
///
/// ```
/// [0x00] "shortcuts" [null]           <- Root map called "shortcuts"
///   [0x00] "0" [null]                 <- First shortcut (index "0")
///     [0x01] "AppName" [null] "Game Title" [null]
///     [0x01] "exe" [null] "/path/to/game" [null]
///     [0x01] "LaunchOptions" [null] "" [null]
///     [0x02] "appid" [null] [4 bytes: little-endian int]
///     [0x02] "IsHidden" [null] [4 bytes: 0 or 1]
///   [0x08]                            <- End of shortcut "0"
///   [0x00] "1" [null]                 <- Second shortcut (index "1")
///     ...
///   [0x08]
/// [0x08]                              <- End of root "shortcuts" map
/// ```
///
/// ## References
/// - https://developer.valvesoftware.com/wiki/VDF
/// - https://developer.valvesoftware.com/wiki/Add_Non-Steam_Game
class VdfBinaryService {
  static const int _typeMap = 0x00;
  static const int _typeString = 0x01;
  static const int _typeInt32 = 0x02;
  static const int _typeInt64 = 0x07;
  static const int _typeEnd = 0x08;

  /// Decodes binary VDF bytes into a JSON-compatible Map.
  ///
  /// The resulting map represents the root object(s).
  Map<String, dynamic> decode(Uint8List bytes) {
    final buffer = ReadBuffer(bytes);
    final result = <String, dynamic>{};

    try {
      while (buffer.hasMore) {
        final type = buffer.readUint8();

        if (type == _typeEnd) {
          break; // Should not happen at root level usually, but just in case
        }

        if (type == _typeMap) {
          final key = buffer.readString();
          final value = _decodeMap(buffer);
          result[key] = value;
        } else if (type == _typeString) {
          final key = buffer.readString();
          final value = buffer.readString();
          result[key] = value;
        } else if (type == _typeInt32) {
          final key = buffer.readString();
          final value = buffer.readInt32();
          result[key] = value;
        } else if (type == _typeInt64) {
          final key = buffer.readString();
          final value = buffer.readInt64();
          result[key] = value;
        } else {
          // Root should ideally contain maps (like 'shortcuts'), but handle others
          // If we encounter garbage or unexpected types at root, we might error.
          throw FormatException('Unexpected root type: 0x${type.toRadixString(16)}');
        }
      }
    } catch (e) {
      // If we run out of bytes legitimately (e.g. after the last 0x08 of the root map),
      // we might catch an error if we try to read more.
      // But loop condition hasMore should prevent that if structure is perfect.
      // Retrowing for now.
      rethrow;
    }

    return result;
  }

  Map<String, dynamic> _decodeMap(ReadBuffer buffer) {
    final map = <String, dynamic>{};

    while (buffer.hasMore) {
      final type = buffer.readUint8();

      if (type == _typeEnd) {
        return map;
      }

      // All types follow [Type] [Key] [Value] pattern
      // Except End (0x08) which has no Key/Value.

      // Read Key
      // Note: KeyType check? No, types 0x00, 0x01, 0x02 imply Key follows.
      // But verify strictly?

      String key;
      try {
        key = buffer.readString();
      } catch (e) {
        // Could fail if 0x08 was expected but missing?
        throw FormatException('Failed to read key for type 0x${type.toRadixString(16)}');
      }

      switch (type) {
        case _typeMap:
          map[key] = _decodeMap(buffer);
          break;
        case _typeString:
          map[key] = buffer.readString();
          break;
        case _typeInt32:
          map[key] = buffer.readInt32();
          break;
        case _typeInt64:
          map[key] = buffer.readInt64();
          break;
        default:
          // Unknown type.
          // If we continue, we risk desync. Throw.
          throw FormatException('Unknown field type: 0x${type.toRadixString(16)} at key "$key"');
      }
    }
    return map;
  }

  /// Encodes a Map into binary VDF format.
  Uint8List encode(Map<String, dynamic> data) {
    final builder = WriteBuffer();

    data.forEach((key, value) {
      _encodeField(builder, key, value);
    });

    // Root level normally doesn't have an End byte if it's just a sequence of items,
    // BUT the items themselves might be Maps.
    // shortcuts.vdf is usually `00 shortcuts ... 08`.
    // My parser logic: `decode` loops until EOF.
    // So `encode` should just write the fields.

    return builder.done();
  }

  void _encodeField(WriteBuffer builder, String key, dynamic value) {
    if (value is Map) {
      builder.writeUint8(_typeMap);
      builder.writeString(key);
      _encodeMapBody(builder, value);
    } else if (value is String) {
      builder.writeUint8(_typeString);
      builder.writeString(key);
      builder.writeString(value);
    } else if (value is int) {
      // Dart ints are 64-bit. If it fits in 32-bit, use Int32, else Int64.
      // 32-bit signed range: -2,147,483,648 to 2,147,483,647
      if (value >= -2147483648 && value <= 2147483647) {
        builder.writeUint8(_typeInt32);
        builder.writeString(key);
        builder.writeInt32(value);
      } else {
        builder.writeUint8(_typeInt64);
        builder.writeString(key);
        builder.writeInt64(value);
      }
    } else {
      // Unsupported type. Convert to string? Or skip?
      // For safety, skip or throw.
      // Steam shortcuts sometimes have bools as ints 0/1.
      // If bool, treat as int.
      if (value is bool) {
        builder.writeUint8(_typeInt32);
        builder.writeString(key);
        builder.writeInt32(value ? 1 : 0);
      } else {
        throw FormatException(
          'Unsupported type for VDF encoding: ${value.runtimeType} (key: $key)',
        );
      }
    }
  }

  void _encodeMapBody(WriteBuffer builder, Map<dynamic, dynamic> map) {
    for (var entry in map.entries) {
      _encodeField(builder, entry.key.toString(), entry.value);
    }
    builder.writeUint8(_typeEnd);
  }
}

// --- Helper Classes for Byte Manipulation ---

class ReadBuffer {
  final Uint8List _bytes;
  int _offset = 0;
  final ByteData _view;

  ReadBuffer(this._bytes) : _view = ByteData.sublistView(_bytes);

  bool get hasMore => _offset < _bytes.length;

  int readUint8() {
    if (_offset >= _bytes.length) throw RangeError('End of buffer');
    return _bytes[_offset++];
  }

  int readInt32() {
    if (_offset + 4 > _bytes.length) throw RangeError('End of buffer reading Int32');
    final val = _view.getInt32(_offset, Endian.little);
    _offset += 4;
    return val;
  }

  int readInt64() {
    if (_offset + 8 > _bytes.length) throw RangeError('End of buffer reading Int64');
    final val = _view.getInt64(_offset, Endian.little);
    _offset += 8;
    return val;
  }

  String readString() {
    final start = _offset;
    while (_offset < _bytes.length && _bytes[_offset] != 0x00) {
      _offset++;
    }
    if (_offset >= _bytes.length) throw FormatException('Unterminated string');

    final strBytes = _bytes.sublist(start, _offset);
    _offset++; // Skip null terminator

    // Should be UTF-8
    return utf8.decode(strBytes);
  }
}

class WriteBuffer {
  final BytesBuilder _builder = BytesBuilder();

  void writeUint8(int value) {
    _builder.addByte(value);
  }

  void writeInt32(int value) {
    final bytes = ByteData(4);
    bytes.setInt32(0, value, Endian.little);
    _builder.add(bytes.buffer.asUint8List());
  }

  void writeInt64(int value) {
    final bytes = ByteData(8);
    bytes.setInt64(0, value, Endian.little);
    _builder.add(bytes.buffer.asUint8List());
  }

  void writeString(String value) {
    final bytes = utf8.encode(value);
    _builder.add(bytes);
    _builder.addByte(0x00); // Null terminator
  }

  Uint8List done() {
    return _builder.toBytes();
  }
}
