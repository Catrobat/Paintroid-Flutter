import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/providers/state/advanced_settings_provider.dart';

class AdvancedSettingsDialog extends ConsumerWidget {
  const AdvancedSettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(advancedSettingsProvider);
    final notifier = ref.read(advancedSettingsProvider.notifier);

    return AlertDialog(
      title: const Text('Advanced Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            title: const Text('Anti-aliasing'),
            value: state.isAntialiasingEnabled,
            onChanged: (bool value) {
              notifier.updateAntialiasing(value);
            },
          ),
          SwitchListTile(
            title: const Text('Smoothing'),
            value: state.isSmoothingEnabled,
            onChanged: (bool value) {
              notifier.updateSmoothing(value);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}