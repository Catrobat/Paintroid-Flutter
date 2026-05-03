import 'package:flutter/material.dart';
import '../../utils/fake_toolbox_state_provider.dart';
import '../../utils/mock_tool.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/providers/state/toolbox_state_data.dart';
import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';
import 'package:paintroid/ui/pages/workspace_page/components/drawing_surface/magnifier_glass.dart';

void main() {
  late ValueNotifier<Offset> focalPointNotifier;

  setUp(() {
    focalPointNotifier = ValueNotifier<Offset>(Offset.zero);
  });

  Widget createSut(ToolType toolType, bool isDown, WidgetTester tester) {
    tester.view.physicalSize = const Size(500, 500);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    return ProviderScope(
      overrides: [
        toolBoxStateProvider.overrideWith(() {
          return FakeToolBoxStateProvider(ToolBoxStateData(
            currentTool: MockTool(toolType),
            isDown: isDown,
          ));
        }),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: MagnifierGlass(
            focalPointNotifier: focalPointNotifier,
            child: Container(
              color: Colors.white,
              width: 500,
              height: 500,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('MagnifierGlass should NOT show when tool is not pipette',
      (tester) async {
    await tester.pumpWidget(createSut(ToolType.BRUSH, true, tester));
    expect(find.byType(RawMagnifier), findsNothing);
  });

  testWidgets('MagnifierGlass should NOT show when isDown is false',
      (tester) async {
    await tester.pumpWidget(createSut(ToolType.PIPETTE, false, tester));
    expect(find.byType(RawMagnifier), findsNothing);
  });

  testWidgets(
      'MagnifierGlass should show when tool is pipette AND isDown is true',
      (tester) async {
    await tester.pumpWidget(createSut(ToolType.PIPETTE, true, tester));
    await tester.pump();
    expect(find.byType(RawMagnifier), findsOneWidget);
  });

  testWidgets('MagnifierGlass should move to opposite side of focal point',
      (tester) async {
    await tester.pumpWidget(createSut(ToolType.PIPETTE, true, tester));

    focalPointNotifier.value = const Offset(100, 100);
    await tester.pump();

    final Positioned magnifierPos = tester.widget(find.byType(Positioned));
    expect(magnifierPos.left, 380);

    focalPointNotifier.value = const Offset(400, 100);
    await tester.pump();

    final Positioned magnifierPos2 = tester.widget(find.byType(Positioned));
    expect(magnifierPos2.left, 20);
  });
}
