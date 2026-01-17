import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroic_lsfg_applier/features/update/domain/entities/update_info.dart';
import 'package:heroic_lsfg_applier/features/update/presentation/cubit/update_cubit.dart';
import 'package:heroic_lsfg_applier/features/update/presentation/cubit/update_state.dart';

/// Dialog for showing update check results and progress
class UpdateDialog extends StatelessWidget {
  const UpdateDialog({super.key});

  /// Show the update dialog
  static Future<void> show(BuildContext context) async {
    // Check for updates first
    context.read<UpdateCubit>().checkForUpdates();
    
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const UpdateDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateCubit, UpdateState>(
      builder: (context, state) {
        return AlertDialog(
          title: _buildTitle(state),
          content: _buildContent(context, state),
          actions: _buildActions(context, state),
        );
      },
    );
  }

  Widget _buildTitle(UpdateState state) {
    return state.when(
      initial: () => const Text('Check for Updates'),
      checking: () => const Text('Checking for Updates'),
      updateAvailable: (info) => const Text('Update Available'),
      upToDate: (version) => const Text('Up to Date'),
      downloading: (info, _, __) => Text('Downloading ${info.version}'),
      extracting: (info) => Text('Extracting ${info.version}'),
      installing: (info) => Text('Installing ${info.version}'),
      completed: (info) => const Text('Update Complete'),
      error: (message) => const Text('Update Error'),
    );
  }

  Widget _buildContent(BuildContext context, UpdateState state) {
    return state.when(
      initial: () => const SizedBox.shrink(),
      checking: () => const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Checking GitHub for updates...'),
        ],
      ),
      updateAvailable: (info) => _UpdateAvailableContent(info: info),
      upToDate: (version) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 48),
          const SizedBox(height: 16),
          Text('You are running the latest version ($version)'),
        ],
      ),
      downloading: (info, received, total) => _DownloadProgressContent(
        bytesReceived: received,
        totalBytes: total,
      ),
      extracting: (info) => const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Extracting update...'),
        ],
      ),
      installing: (info) => const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Installing update...'),
        ],
      ),
      completed: (info) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 48),
          const SizedBox(height: 16),
          Text('Successfully updated to ${info.version}'),
          const SizedBox(height: 8),
          const Text('Restart the app to use the new version.'),
        ],
      ),
      error: (message) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(message),
        ],
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context, UpdateState state) {
    return state.when(
      initial: () => [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
      checking: () => [],
      updateAvailable: (info) => [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Later'),
        ),
        FilledButton.icon(
          onPressed: () => context.read<UpdateCubit>().startUpdate(info),
          icon: const Icon(Icons.download),
          label: const Text('Update Now'),
        ),
      ],
      upToDate: (_) => [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
      downloading: (_, __, ___) => [],
      extracting: (_) => [],
      installing: (_) => [],
      completed: (info) => [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Later'),
        ),
        FilledButton.icon(
          onPressed: () => context.read<UpdateCubit>().restartApp(),
          icon: const Icon(Icons.restart_alt),
          label: const Text('Restart Now'),
        ),
      ],
      error: (_) => [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _UpdateAvailableContent extends StatelessWidget {
  final UpdateInfo info;

  const _UpdateAvailableContent({required this.info});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.new_releases, color: Colors.orange, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Version ${info.version}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (info.downloadSize != null)
                      Text(
                        'Size: ${_formatSize(info.downloadSize!)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (info.releaseNotes.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Release Notes:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(maxHeight: 150),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Text(info.releaseNotes),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class _DownloadProgressContent extends StatelessWidget {
  final int bytesReceived;
  final int totalBytes;

  const _DownloadProgressContent({
    required this.bytesReceived,
    required this.totalBytes,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalBytes > 0 ? bytesReceived / totalBytes : 0.0;
    final percentage = (progress * 100).toStringAsFixed(1);
    final receivedMB = (bytesReceived / (1024 * 1024)).toStringAsFixed(1);
    final totalMB = (totalBytes / (1024 * 1024)).toStringAsFixed(1);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LinearProgressIndicator(value: progress),
        const SizedBox(height: 16),
        Text('$receivedMB MB / $totalMB MB ($percentage%)'),
      ],
    );
  }
}
