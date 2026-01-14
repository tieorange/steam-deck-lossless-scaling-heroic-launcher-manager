import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroic_lsfg_applier/core/theme/steam_deck_constants.dart';

/// Shell widget providing bottom navigation for the app
/// Optimized for Steam Deck with large touch targets
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  
  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.games_outlined, size: SteamDeckConstants.smallIconSize + 4),
            selectedIcon: Icon(Icons.games, size: SteamDeckConstants.smallIconSize + 4),
            label: 'Games',
          ),
          NavigationDestination(
            icon: Icon(Icons.backup_outlined, size: SteamDeckConstants.smallIconSize + 4),
            selectedIcon: Icon(Icons.backup, size: SteamDeckConstants.smallIconSize + 4),
            label: 'Backup',
          ),
        ],
      ),
    );
  }
}
