import 'package:go_router/go_router.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/pages/games_page.dart';
import 'package:heroic_lsfg_applier/features/backup/presentation/pages/backup_page.dart';

/// App router configuration using go_router
class AppRouter {
  AppRouter._();
  
  static const String gamesRoute = '/';
  static const String backupRoute = '/backup';
  
  static final GoRouter router = GoRouter(
    initialLocation: gamesRoute,
    routes: [
      GoRoute(
        path: gamesRoute,
        name: 'games',
        builder: (context, state) => const GamesPage(),
      ),
      GoRoute(
        path: backupRoute,
        name: 'backup',
        builder: (context, state) => const BackupPage(),
      ),
    ],
  );
}
