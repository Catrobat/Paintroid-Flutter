import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tools/tools.dart';

class BottomNavBarInteractions {
  final WidgetTester _tester;

  BottomNavBarInteractions(this._tester);

  Future<BottomNavBarInteractions> openBottomToolSheet() async {
    final firstNavDestination = find.byType(NavigationDestination).first;
    expect(firstNavDestination, findsOneWidget);
    await _tester.tap(firstNavDestination);
    await _tester.pumpAndSettle();
    expect(find.byType(ModalBarrier), findsWidgets);
    return this;
  }

  Future<BottomNavBarInteractions> clickCurrentTool() async {
    final firstNavDestination = find.byType(NavigationDestination).at(1);
    expect(firstNavDestination, findsOneWidget);
    await _tester.tap(firstNavDestination);
    await _tester.pumpAndSettle();
    return this;
  }

  Future<BottomNavBarInteractions> selectTool(ToolData toolData) async {
    await openBottomToolSheet();

    final toolIconButton = _findIconButtonWithLabel(toolData.name);
    expect(toolIconButton, findsOneWidget);

    await _tester.tap(toolIconButton);
    await _tester.pumpAndSettle();
    return this;
  }

  Future<BottomNavBarInteractions> checkActiveToolIconAndLabel(
      ToolData toolData) async {
    final secondNavDestination = find.byType(NavigationDestination).at(1);
    final activeToolIcon = find.descendant(
        of: secondNavDestination,
        matching: find.byWidgetPredicate((Widget widget) =>
            widget is BottomBarIcon && widget.asset == toolData.svgAssetPath));

    final activeToolLabel = find.descendant(
        of: secondNavDestination, matching: find.text(toolData.name));

    expect(activeToolIcon, findsOneWidget);
    expect(activeToolLabel, findsOneWidget);
    return this;
  }

  Finder _findIconButtonWithLabel(String targetLabel) {
    return find.descendant(
      of: find.byWidgetPredicate(
        (Widget widget) =>
            widget is IconButtonWithLabel && widget.label == targetLabel,
      ),
      matching: find.byType(IconButton),
    );
  }

  Finder getAnimatedOpacityFinder(Type type) {
    final child = find.byType(type);
    final animatedOpacityFinder = find.ancestor(
      of: child,
      matching: find.byType(AnimatedOpacity),
    );
    expect(animatedOpacityFinder, findsOneWidget);
    return animatedOpacityFinder;
  }
}
