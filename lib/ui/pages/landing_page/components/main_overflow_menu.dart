// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Project imports:
import 'package:paintroid/core/utils/open_url.dart';
import 'package:paintroid/ui/shared/dialogs/about_dialog.dart';
import 'package:paintroid/ui/shared/pop_menu_button.dart';
import 'package:paintroid/ui/theme/theme.dart';

enum MainOverflowMenuOption {
  rate('Rate us!'),
  help('Help'),
  about('About'),
  feedback('Feedback');

  const MainOverflowMenuOption(this.label);

  final String label;
}

class MainOverflowMenu extends ConsumerStatefulWidget {
  const MainOverflowMenu({super.key});

  @override
  ConsumerState<MainOverflowMenu> createState() => _MainOverFlowMenuState();
}

class _MainOverFlowMenuState extends ConsumerState<MainOverflowMenu> {
  final feedbackUrl = 'mailto:support-paintroid@catrobat.org';
  final iOSAppId = 'org.catrobat.paintroidflutter';
  final androidAppId = 'org.catrobat.paintroid';

  @override
  Widget build(BuildContext context) {
    return StyledPopMenuButton<MainOverflowMenuOption>(
      onSelected: _handleSelectedOption,
      itemBuilder: (BuildContext context) => MainOverflowMenuOption.values
          .map(
            (option) => PopupMenuItem(
              value: option,
              child: Text(
                option.label,
                style: PaintroidTheme.of(context).textTheme.bodyMedium,
              ),
            ),
          )
          .toList(),
    );
  }

  Future<void> _handleSelectedOption(MainOverflowMenuOption option) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    switch (option) {
      case MainOverflowMenuOption.rate:
        LaunchReview.launch(androidAppId: androidAppId, iOSAppId: iOSAppId);
        break;
      case MainOverflowMenuOption.help:
        if (mounted) {
          await Navigator.pushNamed(context, '/OnboardingPage');
        }
        break;
      case MainOverflowMenuOption.about:
        if (mounted) {
          showMyAboutDialog(context, version);
        }
        break;
      case MainOverflowMenuOption.feedback:
        openUrl(feedbackUrl);
        break;
    }
  }
}
