// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

// Project imports:
import 'package:paintroid/app.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/core/providers/state/tools/toolbox/toolbox_state_provider.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/bottom_nav_bar_items.dart';
import 'package:paintroid/ui/utils/top_bar_action_data.dart';

class UIInteraction {
  static final UIInteraction _instance = UIInteraction._internal();

  UIInteraction._internal();

  factory UIInteraction() {
    return _instance;
  }

  late WidgetTester tester;
  final Finder canvas = find.byKey(const ValueKey('CanvasPainter'));
  final Finder checkMark =
      find.byKey(ValueKey(TopBarActionData.CHECKMARK.name));
  final Finder plusButton = find.byKey(ValueKey(TopBarActionData.PLUS.name));
  final Finder toolsTab = find.byKey(const ValueKey(BottomNavBarItem.TOOLS));
  final Finder newImageButton =
      find.byKey(const ValueKey('NewImageActionButton'));

  final int bufferFromEdge = 20;
  late int canvasWidth;
  late int canvasHeight;
  late int centerX;
  late int centerY;
  late int left;
  late int right;
  late int top;
  late int bottom;
  late int halfwayLeft;
  late int halfwayRight;
  late int halfwayTop;
  late int halfwayBottom;
  late Offset topLeft;
  late Offset topCenter;
  late Offset topRight;
  late Offset halfTopLeft;
  late Offset halfTopCenter;
  late Offset halfTopRight;
  late Offset bottomLeft;
  late Offset bottomCenter;
  late Offset bottomRight;
  late Offset halfBottomLeft;
  late Offset halfBottomCenter;
  late Offset halfBottomRight;
  late Offset centerLeft;
  late Offset halfCenterLeft;
  late Offset center;
  late Offset halfCenterRight;
  late Offset centerRight;

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

  selectTool(String toolName) async {
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

  _initializeCanvasDimensions() async {
    final RenderBox canvasBox = tester.renderObject(canvas);
    await tester.pumpAndSettle();
    canvasWidth = canvasBox.size.width.toInt();
    canvasHeight = canvasBox.size.height.toInt();
    centerX = canvasWidth ~/ 2;
    centerY = canvasHeight ~/ 2;
    left = bufferFromEdge;
    right = canvasWidth - bufferFromEdge;
    top = bufferFromEdge;
    bottom = canvasHeight - bufferFromEdge;
    halfwayLeft = canvasWidth ~/ 4;
    halfwayRight = 3 * canvasWidth ~/ 4;
    halfwayTop = canvasHeight ~/ 4;
    halfwayBottom = 3 * canvasHeight ~/ 4;
    topLeft = canvasBox.localToGlobal(Offset(left.toDouble(), top.toDouble()));
    topCenter =
        canvasBox.localToGlobal(Offset(centerX.toDouble(), top.toDouble()));
    topRight =
        canvasBox.localToGlobal(Offset(right.toDouble(), top.toDouble()));
    bottomLeft =
        canvasBox.localToGlobal(Offset(left.toDouble(), bottom.toDouble()));
    centerLeft =
        canvasBox.localToGlobal(Offset(left.toDouble(), centerY.toDouble()));
    bottomRight =
        canvasBox.localToGlobal(Offset(right.toDouble(), bottom.toDouble()));
    centerRight =
        canvasBox.localToGlobal(Offset(right.toDouble(), centerY.toDouble()));
    bottomCenter =
        canvasBox.localToGlobal(Offset(centerX.toDouble(), bottom.toDouble()));
    center =
        canvasBox.localToGlobal(Offset(centerX.toDouble(), centerY.toDouble()));
    halfTopLeft = canvasBox
        .localToGlobal(Offset(halfwayLeft.toDouble(), halfwayTop.toDouble()));
    halfTopCenter = canvasBox
        .localToGlobal(Offset(centerX.toDouble(), halfwayTop.toDouble()));
    halfTopRight = canvasBox
        .localToGlobal(Offset(halfwayRight.toDouble(), halfwayTop.toDouble()));
    halfCenterLeft = canvasBox
        .localToGlobal(Offset(halfwayLeft.toDouble(), centerY.toDouble()));
    halfCenterRight = canvasBox
        .localToGlobal(Offset(halfwayRight.toDouble(), centerY.toDouble()));
    halfBottomLeft = canvasBox.localToGlobal(
        Offset(halfwayLeft.toDouble(), halfwayBottom.toDouble()));
    halfBottomRight = canvasBox.localToGlobal(
        Offset(halfwayRight.toDouble(), halfwayBottom.toDouble()));
    halfBottomCenter = canvasBox
        .localToGlobal(Offset(centerX.toDouble(), halfwayBottom.toDouble()));
  }

  Color getCurrentColor() {
    final container =
        ProviderScope.containerOf(tester.element(find.byType(App)));
    final toolBoxProvider = container.read(toolBoxStateProvider);
    return toolBoxProvider.currentTool.paint.color;
  }

  setColor(Color color) {
    final container =
        ProviderScope.containerOf(tester.element(find.byType(App)));
    final toolBoxProvider = container.read(toolBoxStateProvider);
    toolBoxProvider.currentTool.paint.color = color;
  }

  clickCheckmark() async {
    expect(checkMark, findsOneWidget);
    await tester.tap(checkMark);
    await tester.pumpAndSettle();
  }

  clickPlus() async {
    expect(plusButton, findsOneWidget);
    await tester.tap(plusButton);
    await tester.pumpAndSettle();
  }

  dragFromTo(Offset from, Offset to) async {
    final TestGesture gesture = await tester.startGesture(from);
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    await gesture.moveTo(to);
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    await gesture.up();
    await tester.pumpAndSettle();
  }

  tapAt(Offset position) async {
    await tester.tapAt(position);
    await tester.pumpAndSettle();
  }
}
