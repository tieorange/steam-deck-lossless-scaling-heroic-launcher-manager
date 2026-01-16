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
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final themeMode = state.maybeWhen(
            loaded: (settings) => settings.themeMode,
            orElse: () => ThemeMode.system,
          );
          
          return MaterialApp.router(
            title: 'Heroic LSFG Applier',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
