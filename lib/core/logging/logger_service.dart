import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  static LoggerService get instance => _instance;
  
  File? _logFile;
  final _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  bool _initialized = false;
  
  LoggerService._internal();
  
  Future<void> init() async {
    if (_initialized) return;
    try {
      final dir = await getApplicationDocumentsDirectory();
      _logFile = File('${dir.path}/heroic_lsfg_logs.txt');
      _initialized = true;
      
      // Write initial session header
      final sessionHeader = '\n\n=== Session Started: ${DateTime.now()} ===\n';
      await _logFile?.writeAsString(sessionHeader, mode: FileMode.append);
      
      log('Logger initialized. Log file path: ${_logFile!.path}');
    } catch (e) {
      debugPrint('Failed to initialize logger: $e');
    }
  }
  
  void log(String message) {
    if (kDebugMode && !_initialized) {
      debugPrint('[Logger Not Init] $message');
      return;
    }
    
    final timestamp = _dateFormat.format(DateTime.now());
    final logMessage = '[$timestamp] $message';
    
    // Print to console
    debugPrint(logMessage);
    
    // Append to file (fire and forget to avoid blocking main thread, using sync for reliability might be better but slow)
    // Using sync is safer for crash logs.
    try {
      _logFile?.writeAsStringSync('$logMessage\n', mode: FileMode.append);
    } catch (e) {
      debugPrint('Error writing to log file: $e');
    }
  }
  
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    String fullMessage = '[ERROR] $message';
    if (error != null) {
      fullMessage += '\nError: $error';
    }
    if (stackTrace != null) {
      fullMessage += '\nStackTrace: $stackTrace';
    }
    log(fullMessage);
  }
  
  /// Exports logs using a system save dialog
  Future<String> exportLogs() async {
    if (_logFile == null || !await _logFile!.exists()) {
      return 'No logs found to export.';
    }
    
    try {
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final defaultName = 'heroic_lsfg_logs_$timestamp.txt';
      
      final String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Logs As',
        fileName: defaultName,
        type: FileType.custom,
        allowedExtensions: ['txt'],
      );
      
      if (outputFile == null) {
        return 'Export cancelled by user.';
      }
      
      await _logFile!.copy(outputFile);
      return 'Logs exported to: $outputFile';
    } catch (e) {
      debugPrint('Export failed: $e'); // Keep debugPrint for internal error
      return 'Failed to export logs: $e';
    }
  }
}
