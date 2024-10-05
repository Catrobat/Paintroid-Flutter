import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/utils/widget_identifier.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/bottom_nav_bar_items.dart';
import 'package:paintroid/ui/utils/top_bar_action_data.dart';

class WidgetFinder {
  static final Finder canvas =
      find.byKey(const ValueKey(WidgetIdentifier.canvasPainter));
  static final Finder checkMark =
      find.byKey(ValueKey(TopBarActionData.CHECKMARK.name));
  static final Finder plusButton =
      find.byKey(ValueKey(TopBarActionData.PLUS.name));
  static final Finder toolsTab =
      find.byKey(const ValueKey(BottomNavBarItem.TOOLS));
  static final Finder newImageButton =
      find.byKey(const ValueKey(WidgetIdentifier.newImageActionButton));
  static final Finder undoButton =
      find.byKey(ValueKey(TopBarActionData.UNDO.name));
  static final Finder redoButton =
      find.byKey(ValueKey(TopBarActionData.REDO.name));
  static final Finder circleShapeTypeChip =
      find.byKey(const ValueKey(WidgetIdentifier.circleShapeTypeChip));
  static final Finder backButton =
      find.byKey(const ValueKey(WidgetIdentifier.backButton));
}
