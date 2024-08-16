import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:paintroid/core/tools/tool_data.dart';
import 'package:paintroid/ui/shared/bottom_nav_bar_icon.dart';
import 'package:paintroid/ui/shared/icon_button_with_label.dart';

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

  Future<BottomNavBarInteractions> openColorPicker() async {
    final thirdNavDestination = find.byType(NavigationDestination).at(2);
    expect(thirdNavDestination, findsOneWidget);
    await _tester.tap(thirdNavDestination);
    await _tester.pumpAndSettle();
    expect(find.byType(ModalBarrier), findsWidgets);
    return this;
  }

  Future<BottomNavBarInteractions> selectColor(Color color) async {
    await openColorPicker();

    final colorButton = _findButtonWithColor(color);
    expect(colorButton, findsOneWidget);

    await _tester.tap(colorButton);
    await _tester.pumpAndSettle();
    final applyButton = find.descendant(
      of: find.byWidgetPredicate((Widget widget) => widget is Row),
      matching: find.text('APPLY'),
    );
    expect(applyButton, findsWidgets);
    await _tester.dragUntilVisible(
        applyButton, find.byType(SingleChildScrollView), const Offset(0, 50));
    await _tester.pumpAndSettle();
    await _tester.tap(applyButton);
    await _tester.pumpAndSettle();
    return this;
  }

  Future<BottomNavBarInteractions> checkActiveColor(Color color) async {
    final thirdNavDestination = find.byType(NavigationDestination).at(2);
    final activeColor = find.descendant(
        of: thirdNavDestination,
        matching: find.byWidgetPredicate((Widget widget) =>
            widget is InkWell &&
            widget.child is Container &&
            (widget.child as Container).decoration is BoxDecoration &&
            ((widget.child as Container).decoration as BoxDecoration).color ==
                color));

    expect(activeColor, findsOneWidget);
    return this;
  }

  Finder _findButtonWithColor(Color color) {
    return find.descendant(
      of: find.byWidgetPredicate((Widget widget) =>
          widget is GestureDetector &&
          widget.child is Container &&
          (widget.child as Container).decoration is BoxDecoration &&
          ((widget.child as Container).decoration as BoxDecoration).color ==
              color),
      matching: find.byType(Container),
    );
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
