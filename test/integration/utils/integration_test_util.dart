import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:paintroid/app.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/providers/state/tools/toolbox/toolbox_state_provider.dart';
import 'package:paintroid/core/tools/line_tool/line_tool_vertex.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/bottom_nav_bar_items.dart';

class InteractionUtil {
  static final InteractionUtil _instance = InteractionUtil._internal();

  InteractionUtil._internal();

  factory InteractionUtil() {
    return _instance;
  }

  late WidgetTester tester;
  final Finder canvas = find.byKey(const ValueKey('CanvasPainter'));
  final Finder checkMark = find.byKey(const ValueKey('CheckMarkButton'));
  final Finder plusButton = find.byKey(const ValueKey('PlusButton'));
  final Finder toolsTab = find.byKey(const ValueKey(BottomNavBarItem.TOOLS));
  final Finder newImageButton =
      find.byKey(const ValueKey('NewImageActionButton'));

  late double canvasWidth;
  late double canvasHeight;
  late Offset topLeft;
  late Offset topCenter;
  late Offset topRight;
  late Offset bottomLeft;
  late Offset bottomCenter;
  late Offset bottomRight;
  late Offset centerLeft;
  late Offset centerRight;
  late Offset center;

  void initialize(WidgetTester tester) {
    this.tester = tester;
  }

  Future<Color> getPixelColor(int x, int y) async {
    final container =
        ProviderScope.containerOf(tester.element(find.byType(App)));
    final canvasStateNotifier = container.read(canvasStateProvider.notifier);
    await canvasStateNotifier.updateCachedImage();
    final cachedImage = container.read(canvasStateProvider).cachedImage;

    if (cachedImage == null) return Colors.transparent;

    final byteData = await cachedImage.toByteData();
    if (byteData == null) return Colors.transparent;
    final rawBytes = byteData.buffer.asUint8List();
    final image =
        img.Image.fromBytes(cachedImage.width, cachedImage.height, rawBytes);
    var pixel = image.getPixel(x, y);

    final a = img.getAlpha(pixel);
    final r = img.getRed(pixel);
    final g = img.getGreen(pixel);
    final b = img.getBlue(pixel);

    final argbColor = (a << 24) | (r << 16) | (g << 8) | b;
    return Color(argbColor);
  }

  Future<void> selectTool(String toolName) async {
    expect(newImageButton, findsOneWidget);
    await tester.tap(newImageButton);
    await tester.pumpAndSettle();

    expect(toolsTab, findsOneWidget);
    await tester.tap(toolsTab);
    await tester.pumpAndSettle();

    final Finder tool = find.byKey(ValueKey(toolName));

    expect(tool, findsOneWidget);
    await tester.tap(tool);
    await tester.pumpAndSettle();
    await _initializeCanvasDimensions();
  }

  Future<void> _initializeCanvasDimensions() async {
    final RenderBox canvasBox = tester.renderObject(canvas);
    await tester.pumpAndSettle();
    canvasWidth = canvasBox.size.width;
    canvasHeight = canvasBox.size.height;
    topLeft = canvasBox.localToGlobal(const Offset(
      Vertex.VERTEX_RADIUS,
      Vertex.VERTEX_RADIUS,
    ));
    topCenter = canvasBox.localToGlobal(Offset(
      canvasWidth / 2,
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
    centerLeft = canvasBox.localToGlobal(Offset(
      Vertex.VERTEX_RADIUS,
      canvasHeight / 2,
    ));
    bottomRight = canvasBox.localToGlobal(Offset(
      canvasWidth - Vertex.VERTEX_RADIUS,
      canvasHeight - Vertex.VERTEX_RADIUS,
    ));
    centerRight = canvasBox.localToGlobal(Offset(
      canvasWidth - Vertex.VERTEX_RADIUS,
      canvasHeight / 2,
    ));
    bottomCenter = canvasBox.localToGlobal(Offset(
      canvasWidth / 2,
      canvasHeight - Vertex.VERTEX_RADIUS,
    ));
    center = canvasBox.localToGlobal(Offset(
      canvasWidth / 2,
      canvasHeight / 2,
    ));
  }

  Color getCurrentColor() {
    final container =
        ProviderScope.containerOf(tester.element(find.byType(App)));
    final toolBoxProvider = container.read(toolBoxStateProvider);
    return toolBoxProvider.currentTool.paint.color;
  }

  Future<void> clickCheckmark() async {
    expect(checkMark, findsOneWidget);
    await tester.tap(checkMark);
    await tester.pumpAndSettle();
  }

  Future<void> clickPlus() async {
    expect(plusButton, findsOneWidget);
    await tester.tap(plusButton);
    await tester.pumpAndSettle();
  }
}
