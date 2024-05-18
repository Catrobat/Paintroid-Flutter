import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:paintroid/core/tools/line_tool/line_tool_vertex.dart';
import 'package:paintroid/core/tools/tool_data.dart';
import 'package:paintroid/main.dart' as app;
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/bottom_nav_bar_items.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final Finder canvas = find.byKey(const ValueKey('CanvasPainter'));
  late final double canvasWidth;
  late final double canvasHeight;
  late final Offset topLeft;
  late final Offset topRight;
  late final Offset bottomLeft;
  late final Offset bottomRight;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('showOnboarding', false);
    app.main();
  });

  Future<void> selectLineTool(WidgetTester tester) async {
    final Finder newImageButton = find.byIcon(Icons.add);
    expect(newImageButton, findsOneWidget);
    await tester.tap(newImageButton);
    await tester.pumpAndSettle();

    final Finder toolsTab = find.byKey(const ValueKey(BottomNavBarItem.TOOLS));
    expect(toolsTab, findsOneWidget);
    await tester.tap(toolsTab);
    await tester.pumpAndSettle();

    final Finder lineTool = find.byKey(ValueKey(ToolData.LINE.name));
    expect(lineTool, findsOneWidget);
    await tester.tap(lineTool);
    await tester.pumpAndSettle();
  }

  Future<void> initializeCanvasSize(WidgetTester tester) async {
    final RenderBox canvasBox = tester.renderObject(canvas);
    await tester.pumpAndSettle();
    canvasWidth = canvasBox.size.width;
    canvasHeight = canvasBox.size.height;
    topLeft = canvasBox.localToGlobal(const Offset(
      Vertex.VERTEX_RADIUS,
      Vertex.VERTEX_RADIUS,
    ));
    topRight = canvasBox.localToGlobal(Offset(
      canvasWidth - Vertex.VERTEX_RADIUS,
      Vertex.VERTEX_RADIUS,
    ));
    bottomLeft = canvasBox.localToGlobal(Offset(
      Vertex.VERTEX_RADIUS,
      canvasHeight - Vertex.VERTEX_RADIUS,
    ));
    bottomRight = canvasBox.localToGlobal(Offset(
      canvasWidth - Vertex.VERTEX_RADIUS,
      canvasHeight - Vertex.VERTEX_RADIUS,
    ));
  }

  testWidgets('test', (WidgetTester tester) async {
    await tester.pumpAndSettle();
    await selectLineTool(tester);

    await initializeCanvasSize(tester);

    final TestGesture gesture = await tester.startGesture(topLeft);
    await tester.pump();

    await gesture.moveTo(topRight);
    await tester.pump();
    await gesture.moveTo(bottomLeft);
    await tester.pump();

    await gesture.moveTo(bottomRight);
    await tester.pump();
  });
}
