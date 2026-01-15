import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:heroic_lsfg_applier/core/theme/steam_deck_constants.dart';
import 'package:heroic_lsfg_applier/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:heroic_lsfg_applier/features/settings/presentation/cubit/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (msg) => Center(child: Text('Error: $msg')),
            loaded: (settings) => ListView(
              padding: const EdgeInsets.all(SteamDeckConstants.cardPadding),
              children: [
                _SettingsSection(
                  title: 'Appearance',
                  children: [
                    ListTile(
                      title: const Text('Theme Mode'),
                      subtitle: Text(_getThemeModeName(settings.themeMode)),
                      trailing: SegmentedButton<ThemeMode>(
                        segments: const [
                          ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.auto_mode), label: Text('System')),
                          ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode), label: Text('Light')),
                          ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode), label: Text('Dark')),
                        ],
                        selected: {settings.themeMode},
                        onSelectionChanged: (Set<ThemeMode> newSelection) {
                          context.read<SettingsCubit>().toggleTheme(newSelection.first);
                        },
                        showSelectedIcon: false,
                        style: ButtonStyle(
                           visualDensity: VisualDensity.compact,
                           padding: WidgetStateProperty.all(EdgeInsets.zero),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SettingsSection(
                  title: 'Behavior',
                  children: [
                    SwitchListTile(
                      title: const Text('Auto-Backup Before Apply'),
                      subtitle: const Text('Create a backup automatically before applying changes'),
                      value: settings.autoBackup,
                      onChanged: (value) => context.read<SettingsCubit>().toggleAutoBackup(value),
                    ),
                    SwitchListTile(
                      title: const Text('Show Confirmation Dialogs'),
                      subtitle: const Text('Ask for confirmation before apply/restore actions'),
                      value: settings.showConfirmations,
                      onChanged: (value) => context.read<SettingsCubit>().toggleConfirmations(value),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SettingsSection(
                  title: 'App Info',
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('About'),
                      subtitle: const Text('Version, paths, and info'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                         context.push('/settings/about');
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system: return 'System Default';
      case ThemeMode.light: return 'Light Mode';
      case ThemeMode.dark: return 'Dark Mode';
    }
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}
