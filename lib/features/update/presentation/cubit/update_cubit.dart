import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroic_lsfg_applier/features/update/data/services/update_service.dart';
import 'package:heroic_lsfg_applier/features/update/domain/entities/update_info.dart';
import 'package:heroic_lsfg_applier/features/update/presentation/cubit/update_state.dart';

/// Cubit for managing update checking and installation
class UpdateCubit extends Cubit<UpdateState> {
  final UpdateService _updateService;
  
  UpdateCubit(this._updateService) : super(const UpdateState.initial());
  
  /// Check for available updates
  Future<void> checkForUpdates({bool silent = false}) async {
    if (!silent) {
      emit(const UpdateState.checking());
    }
    
    final result = await _updateService.checkForUpdates();
    
    result.when(
      available: (info) {
        emit(UpdateState.updateAvailable(info));
      },
      upToDate: (version) {
        emit(UpdateState.upToDate(version));
      },
      error: (message) {
        if (!silent) {
          emit(UpdateState.error(message));
        } else {
          emit(const UpdateState.initial());
        }
      },
    );
  }
  
  /// Start downloading and installing an update
  Future<void> startUpdate(UpdateInfo info) async {
    await for (final progress in _updateService.downloadAndInstall(info)) {
      progress.when(
        downloading: (received, total) {
          emit(UpdateState.downloading(
            info: info,
            bytesReceived: received,
            totalBytes: total,
          ));
        },
        extracting: () {
          emit(UpdateState.extracting(info: info));
        },
        installing: () {
          emit(UpdateState.installing(info: info));
        },
        completed: () {
          emit(UpdateState.completed(info: info));
        },
        failed: (message) {
          emit(UpdateState.error(message));
        },
      );
    }
  }
  
  /// Restart the app after successful update
  Future<void> restartApp() async {
    await _updateService.restartApp();
  }
  
  /// Dismiss update notification
  void dismissUpdate() {
    emit(const UpdateState.initial());
  }
  
  /// Get current app version
  String get currentVersion => _updateService.currentVersion;
}
