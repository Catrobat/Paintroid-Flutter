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
  static final Finder backButton =
      find.byKey(const ValueKey(WidgetIdentifier.backButton));

  static final Finder ellipseShapeTypeChip =
      find.byKey(const ValueKey(WidgetIdentifier.ellipseShapeTypeChip));
  static final Finder squareShapeTypeChip =
      find.byKey(const ValueKey(WidgetIdentifier.squareShapeTypeChip));
  static final Finder heartShapeTypeChip =
      find.byKey(const ValueKey(WidgetIdentifier.heartShapeTypeChip));
  static final Finder starShapeTypeChip =
      find.byKey(const ValueKey(WidgetIdentifier.starShapeTypeChip));

  static final Finder fillStyleChip =
      find.byKey(const ValueKey(WidgetIdentifier.fillStyleChip));
  static final Finder outlineStyleChip =
      find.byKey(const ValueKey(WidgetIdentifier.outlineStyleChip));
  static final Finder dashedStyleChip =
      find.byKey(const ValueKey(WidgetIdentifier.dashedStyleChip));
  static final Finder fillAndDashedStyleChip =
      find.byKey(const ValueKey(WidgetIdentifier.fillAndDashedStyleChip));

  static final Finder genericDialogActionDone =
      find.byKey(const ValueKey(WidgetIdentifier.genericDialogActionDone));
  static final Finder genericDialogActionDiscard =
      find.byKey(const ValueKey(WidgetIdentifier.genericDialogActionDiscard));
  static final Finder genericDialogActionSave =
      find.byKey(const ValueKey(WidgetIdentifier.genericDialogActionSave));
  static final Finder genericDialogActionPhotos =
      find.byKey(const ValueKey(WidgetIdentifier.genericDialogActionPhotos));
  static final Finder genericDialogActionFiles =
      find.byKey(const ValueKey(WidgetIdentifier.genericDialogActionFiles));
  static final Finder genericDialogActionCancel =
      find.byKey(const ValueKey(WidgetIdentifier.genericDialogActionCancel));
  static final Finder genericDialogActionDelete =
      find.byKey(const ValueKey(WidgetIdentifier.genericDialogActionDelete));
  static final Finder genericDialogActionOk =
      find.byKey(const ValueKey(WidgetIdentifier.genericDialogActionOk));
  static final Finder genericDialogActionRename =
      find.byKey(const ValueKey(WidgetIdentifier.genericDialogActionRename));
  static final Finder genericDialogActionYes =
      find.byKey(const ValueKey(WidgetIdentifier.genericDialogActionYes));
}
