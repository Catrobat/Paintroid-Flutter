// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
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
