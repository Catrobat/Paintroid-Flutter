import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/localization/app_localizations.dart';
import 'package:paintroid/core/providers/state/advanced_settings_panel_visibility_provider.dart';
import 'package:paintroid/core/providers/state/advanced_settings_provider.dart';
import 'package:paintroid/core/providers/state/advanced_settings_state_data.dart';

class AdvancedSettingsPanel extends ConsumerWidget {
  const AdvancedSettingsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final state = ref.watch(advancedSettingsProvider);
    final notifier = ref.read(advancedSettingsProvider.notifier);
    final panelVisibility =
        ref.read(advancedSettingsPanelVisibilityProvider.notifier);

    return Column(
      children: [
        const Spacer(),
        _buildSettingsCard(
          context: context,
          localizations: localizations,
          state: state,
          notifier: notifier,
          onClose: panelVisibility.hide,
        ),
      ],
    );
  }

  Widget _buildSettingsCard({
    required BuildContext context,
    required AppLocalizations localizations,
    required AdvancedSettingsStateData state,
    required AdvancedSettingsProvider notifier,
    required VoidCallback onClose,
  }) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(localizations: localizations, onClose: onClose),
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
    );
  }

  Widget _buildHeader({
    required AppLocalizations localizations,
    required VoidCallback onClose,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(localizations.menuAdvanced),
          IconButton(icon: const Icon(Icons.close), onPressed: onClose),
        ],
      ),
    );
  }
}
