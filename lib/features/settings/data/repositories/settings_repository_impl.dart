import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:heroic_lsfg_applier/core/error/failures.dart';
import 'package:heroic_lsfg_applier/features/settings/domain/entities/settings_entity.dart';
import 'package:heroic_lsfg_applier/features/settings/domain/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of SettingsRepository using SharedPreferences
class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences _prefs;
  
  static const String _themeKey = 'theme_mode';
  static const String _autoBackupKey = 'auto_backup';
  static const String _confirmationsKey = 'show_confirmations';
  static const String _checkUpdatesKey = 'check_for_updates_on_startup';
  
  SettingsRepositoryImpl(this._prefs);
  
  @override
  Future<Result<Settings>> getSettings() async {
    try {
      final themeIndex = _prefs.getInt(_themeKey) ?? ThemeMode.system.index;
      final autoBackup = _prefs.getBool(_autoBackupKey) ?? true;
      final showConfirmations = _prefs.getBool(_confirmationsKey) ?? true;
      final checkForUpdates = _prefs.getBool(_checkUpdatesKey) ?? true;
      
      // Safety check for theme index
      final themeMode = ThemeMode.values.length > themeIndex 
          ? ThemeMode.values[themeIndex] 
          : ThemeMode.system;
      
      return Right(Settings(
        themeMode: themeMode,
        autoBackup: autoBackup,
        showConfirmations: showConfirmations,
        checkForUpdatesOnStartup: checkForUpdates,
      ));
    } catch (e) {
      return Left(CacheFailure('Failed to load settings: $e'));
    }
  }
  
  @override
  Future<Result<Unit>> saveSettings(Settings settings) async {
    try {
      await Future.wait([
        _prefs.setInt(_themeKey, settings.themeMode.index),
        _prefs.setBool(_autoBackupKey, settings.autoBackup),
        _prefs.setBool(_confirmationsKey, settings.showConfirmations),
        _prefs.setBool(_checkUpdatesKey, settings.checkForUpdatesOnStartup),
      ]);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Failed to save settings: $e'));
    }
  }
}
