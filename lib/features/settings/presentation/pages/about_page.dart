import 'package:flutter/material.dart';
import 'package:heroic_lsfg_applier/core/platform/platform_service.dart';
import 'package:heroic_lsfg_applier/core/theme/steam_deck_constants.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine detected paths (simplified for display)
    // In a real scenario, we might want to inject PlatformService or read from a provider if paths were dynamic.
    // For now, we instantiate a service just to get defaults or current platform logic.
    final platformService = createPlatformService();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(SteamDeckConstants.spaciousPadding),
        children: [
          const Center(
            child: Icon(Icons.settings_applications, size: 80),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Heroic LSFG Applier',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const Center(
            child: Text('Version 1.0.0'),
          ),
          const SizedBox(height: 32),
          const _SectionHeader(title: 'Detected Paths'),
          _PathTile(
            title: 'Heroic Config',
            path: platformService.gameConfigPath,
          ),
          _PathTile(
            title: 'Icon Cache',
            path: platformService.iconCachePath,
          ),
          _PathTile(
            title: 'Backup Location',
            path: platformService.backupBasePath,
          ),
          _PathTile(
            title: 'Lutris Config',
            path: platformService.lutrisConfigPath,
          ),
          _PathTile(
            title: 'OGI Library',
            path: platformService.ogiLibraryPath,
          ),
          const SizedBox(height: 32),
          const Text(
            'This application modifies configuration files to enable Lossless Scaling Frame Generation via the Decky LSFG plugin. '
            'Always verify your backups if unsure.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _PathTile extends StatelessWidget {
  final String title;
  final String path;

  const _PathTile({required this.title, required this.path});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(path, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
        dense: true,
      ),
    );
  }
}
