import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:heroic_lsfg_applier/core/di/injection.dart';
import 'package:heroic_lsfg_applier/core/logging/logger_service.dart';
import 'package:heroic_lsfg_applier/core/router/app_router.dart';
import 'package:heroic_lsfg_applier/core/theme/app_theme.dart';
import 'package:heroic_lsfg_applier/features/backup/domain/repositories/backup_repository.dart';
import 'package:heroic_lsfg_applier/features/backup/presentation/cubit/backup_cubit.dart';
import 'package:heroic_lsfg_applier/features/games/domain/repositories/game_repository.dart';
import 'package:heroic_lsfg_applier/features/games/domain/usecases/apply_lsfg_usecase.dart';
import 'package:heroic_lsfg_applier/features/games/domain/usecases/remove_lsfg_usecase.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/cubit/games_cubit.dart';
import 'package:heroic_lsfg_applier/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:heroic_lsfg_applier/features/settings/presentation/cubit/settings_state.dart';
import 'package:heroic_lsfg_applier/features/update/data/services/update_service.dart';
import 'package:heroic_lsfg_applier/features/update/presentation/cubit/update_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize logging
  await LoggerService.instance.init();
  
  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  // Configure dependency injection
  await configureDependencies(prefs);
  
  runApp(const HeroicLsfgApp());
}

class HeroicLsfgApp extends StatelessWidget {
  const HeroicLsfgApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GamesCubit(
            getIt<GameRepository>(),
            getIt<ApplyLsfgUseCase>(),
            getIt<RemoveLsfgUseCase>(),
          ),
        ),
        BlocProvider(
          create: (_) => BackupCubit(getIt<BackupRepository>()),
        ),
        BlocProvider(
          create: (_) => SettingsCubit(getIt())..loadSettings(),
        ),
        BlocProvider(
          create: (_) => UpdateCubit(UpdateService()),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final themeMode = state.maybeWhen(
            loaded: (settings) => settings.themeMode,
            orElse: () => ThemeMode.system,
          );
          
          // Check for updates on startup if enabled
          final shouldCheckUpdates = state.maybeWhen(
            loaded: (settings) => settings.checkForUpdatesOnStartup,
            orElse: () => false,
          );
          
          return _AppWithUpdateCheck(
            themeMode: themeMode,
            shouldCheckUpdates: shouldCheckUpdates,
          );
        },
      ),
    );
  }
}

/// Wrapper widget to handle update check on startup
class _AppWithUpdateCheck extends StatefulWidget {
  final ThemeMode themeMode;
  final bool shouldCheckUpdates;

  const _AppWithUpdateCheck({
    required this.themeMode,
    required this.shouldCheckUpdates,
  });

  @override
  State<_AppWithUpdateCheck> createState() => _AppWithUpdateCheckState();
}

class _AppWithUpdateCheckState extends State<_AppWithUpdateCheck> {
  bool _hasCheckedForUpdates = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkForUpdatesIfNeeded();
  }

  void _checkForUpdatesIfNeeded() {
    if (!_hasCheckedForUpdates && widget.shouldCheckUpdates) {
      _hasCheckedForUpdates = true;
      // Check silently on startup - don't show loading dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<UpdateCubit>().checkForUpdates(silent: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Heroic LSFG Applier',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: widget.themeMode,
      routerConfig: AppRouter.router,
    );
  }
}
