import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_entity.freezed.dart';

/// App settings and preferences
@freezed
class Settings with _$Settings {
  const factory Settings({
    /// Current theme mode
    @Default(ThemeMode.system) ThemeMode themeMode,
    
    /// Whether to automatically backup before applying LSFG
    @Default(true) bool autoBackup,
    
    /// Whether to show confirmation dialogs for actions
    @Default(true) bool showConfirmations,
    
    /// Whether to check for updates on app startup
    @Default(true) bool checkForUpdatesOnStartup,
  }) = _Settings;
}
