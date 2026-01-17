import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroic_lsfg_applier/features/settings/domain/entities/settings_entity.dart';
import 'package:heroic_lsfg_applier/features/settings/domain/repositories/settings_repository.dart';
import 'package:heroic_lsfg_applier/features/settings/presentation/cubit/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _repository;
  
  SettingsCubit(this._repository) : super(const SettingsState.initial());
  
  Future<void> loadSettings() async {
    emit(const SettingsState.loading());
    final result = await _repository.getSettings();
    result.fold(
      (failure) => emit(SettingsState.error(failure.message)),
      (settings) => emit(SettingsState.loaded(settings)),
    );
  }
  
  Future<void> updateSettings(Settings newSettings) async {
    if (state is SettingsLoaded) {
      final result = await _repository.saveSettings(newSettings);
      result.fold(
        (failure) => emit(SettingsState.error(failure.message)),
        (_) => emit(SettingsState.loaded(newSettings)),
      );
    }
  }
  
  Future<void> toggleTheme(ThemeMode mode) async {
    if (state is SettingsLoaded) {
      final current = (state as SettingsLoaded).settings;
      final newSettings = current.copyWith(themeMode: mode);
      await updateSettings(newSettings);
    }
  }
  
  Future<void> toggleAutoBackup(bool value) async {
    if (state is SettingsLoaded) {
      final current = (state as SettingsLoaded).settings;
      final newSettings = current.copyWith(autoBackup: value);
      await updateSettings(newSettings);
    }
  }
  
  Future<void> toggleConfirmations(bool value) async {
    if (state is SettingsLoaded) {
      final current = (state as SettingsLoaded).settings;
      final newSettings = current.copyWith(showConfirmations: value);
      await updateSettings(newSettings);
    }
  }
  
  Future<void> toggleCheckForUpdates(bool value) async {
    if (state is SettingsLoaded) {
      final current = (state as SettingsLoaded).settings;
      final newSettings = current.copyWith(checkForUpdatesOnStartup: value);
      await updateSettings(newSettings);
    }
  }
}
