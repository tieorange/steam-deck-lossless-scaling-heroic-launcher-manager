import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroic_lsfg_applier/core/platform/platform_service.dart';
import 'package:heroic_lsfg_applier/core/router/app_router.dart';
import 'package:heroic_lsfg_applier/core/theme/app_theme.dart';
import 'package:heroic_lsfg_applier/features/backup/data/repositories/backup_repository_impl.dart';
import 'package:heroic_lsfg_applier/features/backup/presentation/cubit/backup_cubit.dart';
import 'package:heroic_lsfg_applier/features/games/data/repositories/game_repository_impl.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/cubit/games_cubit.dart';

void main() {
  runApp(const HeroicLsfgApp());
}

class HeroicLsfgApp extends StatelessWidget {
  const HeroicLsfgApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create platform service (auto-detects Mac vs Linux)
    final platformService = createPlatformService();
    
    // Create repositories
    final gameRepository = GameRepositoryImpl(platformService);
    final backupRepository = BackupRepositoryImpl(platformService);
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GamesCubit(gameRepository),
        ),
        BlocProvider(
          create: (_) => BackupCubit(backupRepository),
        ),
      ],
      child: MaterialApp.router(
        title: 'Heroic LSFG Applier',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
