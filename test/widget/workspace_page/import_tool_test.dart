import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/state/toolbox_state_data.dart';
import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';
import 'package:paintroid/core/localization/app_localizations.dart';
import 'package:paintroid/core/tools/bounding_box.dart';
import 'package:paintroid/core/tools/implementation/import_tool.dart';
import 'package:paintroid/ui/pages/workspace_page/components/top_bar/top_app_bar.dart';
import 'package:paintroid/ui/theme/theme.dart';
import 'package:paintroid/ui/utils/top_bar_action_data.dart';

import '../../utils/fake_toolbox_state_provider.dart';

void main() {
  Widget createSut(ImportTool importTool) {
    final lightTheme = LightPaintroidThemeData();
    final darkTheme = DarkPaintroidThemeData();
    return ProviderScope(
      overrides: [
        toolBoxStateProvider.overrideWith(() => FakeToolBoxStateProvider(
              ToolBoxStateData(currentTool: importTool, isDown: false),
            )),
      ],
      child: PaintroidTheme(
        lightTheme: lightTheme,
        darkTheme: darkTheme,
        child: MaterialApp(
          theme: lightTheme.materialThemeData,
          darkTheme: darkTheme.materialThemeData,
          localizationsDelegates: const [
            AppLocalizations.delegate,
          ],
          home: const Scaffold(appBar: TopAppBar(title: 'Paintroid')),
        ),
      ),
    );
  }

  ImportTool createImportTool() {
    return ImportTool(
      commandManager: CommandManager(),
      commandFactory: const CommandFactory(),
      boundingBox: BoundingBox.fromCenter(
        center: const Offset(100, 100),
        width: 100,
        height: 100,
      ),
      type: ToolType.IMPORT,
    );
  }

  testWidgets('shows a disabled checkmark until an image is selected',
      (tester) async {
    await tester.pumpWidget(createSut(createImportTool()));

    final checkmark = tester.widget<IconButton>(
      find.byKey(ValueKey(TopBarActionData.CHECKMARK.name)),
    );
    expect(checkmark.onPressed, isNull);
  });
}
