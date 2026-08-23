import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/localization/app_localizations.dart';
import 'package:paintroid/core/providers/state/advanced_settings_panel_visibility_provider.dart';
import 'package:paintroid/core/providers/state/advanced_settings_provider.dart';

class AdvancedSettingsPanel extends ConsumerWidget {
  const AdvancedSettingsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final state = ref.watch(advancedSettingsProvider);
    final notifier = ref.read(advancedSettingsProvider.notifier);

    return Column(
      children: [
        const Spacer(),
        Material(
          color: Theme.of(context).colorScheme.surface,
          elevation: 4,
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(localizations.menuAdvanced),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => ref
                          .read(advancedSettingsPanelVisibilityProvider.notifier)
                          .hide(),
                    ),
                  ],
                ),
              ),
              SwitchListTile(
                title: Text(localizations.dialogAntialiasing),
                value: state.isAntialiasingEnabled,
                onChanged: notifier.updateAntialiasing,
              ),
              SwitchListTile(
                title: Text(localizations.dialogSmoothing),
                value: state.isSmoothingEnabled,
                onChanged: notifier.updateSmoothing,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
