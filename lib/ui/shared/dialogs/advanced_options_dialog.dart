import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:paintroid/core/localization/app_localizations.dart';
import 'package:paintroid/core/providers/state/advanced_options_state_provider.dart';
import 'package:paintroid/core/utils/widget_identifier.dart';
import 'package:paintroid/ui/shared/dialogs/generic_dialog.dart';
import 'package:paintroid/ui/theme/theme.dart';

Future<void> showAdvancedOptionsDialog(BuildContext context) =>
    showGeneralDialog<void>(
      context: context,
      pageBuilder: (_, __, ___) => const AdvancedOptionsDialog(),
      barrierDismissible: true,
      barrierLabel: 'Advanced Options Dialog',
    );

class AdvancedOptionsDialog extends ConsumerWidget {
  const AdvancedOptionsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final theme = PaintroidTheme.of(context);
    final advancedOptionsStateData = ref.watch(advancedOptionsState);
    final notifier = ref.read(advancedOptionsState.notifier);

    return GenericDialog(
      key: const ValueKey(WidgetIdentifier.advancedOptionsDialog),
      title: localizations.advancedOptions,
      actions: [
        GenericDialogAction(
          title: 'CANCEL',
          onPressed: () => Navigator.of(context).pop(),
          identifier: WidgetIdentifier.genericDialogActionCancel,
        ),
        GenericDialogAction(
          title: 'OK',
          onPressed: () => Navigator.of(context).pop(),
          identifier: WidgetIdentifier.genericDialogActionOk,
        ),
      ],
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              key: const ValueKey(WidgetIdentifier.antialiasingSwitch),
              title: Text(
                'Antialiasing',
                style: TextStyle(color: theme.shadowColor),
              ),
              value: advancedOptionsStateData.isAntialiasingEnabled,
              activeColor: theme.primaryColor,
              onChanged: (_) => notifier.toggleAntialiasing(),
            ),
            SwitchListTile(
              key: const ValueKey(WidgetIdentifier.smoothingSwitch),
              title: Text(
                'Smoothing',
                style: TextStyle(color: theme.shadowColor),
              ),
              value: advancedOptionsStateData.isSmoothingEnabled,
              activeColor: theme.primaryColor,
              onChanged: (_) => notifier.toggleSmoothing(),
            ),
          ],
        ),
      ),
    );
  }
}
