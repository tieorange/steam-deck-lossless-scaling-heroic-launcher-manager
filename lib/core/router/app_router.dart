import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroic_lsfg_applier/core/router/app_shell.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/pages/games_page.dart';
import 'package:heroic_lsfg_applier/features/backup/presentation/pages/backup_page.dart';

/// App router configuration using go_router with bottom navigation
class AppRouter {
  AppRouter._();
  
  static const String gamesRoute = '/games';
  static const String backupRoute = '/backup';
  
  // Navigation keys for maintaining state
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: gamesRoute,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(),
            routes: [
              GoRoute(
                path: gamesRoute,
                name: 'games',
                builder: (context, state) => const GamesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(),
            routes: [
              GoRoute(
                path: backupRoute,
                name: 'backup',
                builder: (context, state) => const BackupPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
