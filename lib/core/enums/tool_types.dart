import 'package:paintroid/core/localization/app_localizations.dart';

enum ToolType {
  BRUSH,
  HAND,
  ERASER,
  LINE,
  SHAPES,
  FILL,
  SPRAY,
  CURSOR,
  TEXT,
  CLIPBOARD,
  TRANSFORM,
  IMPORT,
  PIPETTE,
  WATERCOLOR,
  SMUDGE,
  CLIPPING;

  String localizedName(AppLocalizations localizations) {
    switch(this){
      case ToolType.BRUSH:
        return localizations.button_brush;
      case ToolType.CLIPBOARD:
        return localizations.button_clipboard;
      case ToolType.CLIPPING:
        return localizations.button_clip;
      case ToolType.CURSOR:
        return localizations.button_cursor;
      case ToolType.ERASER:
        return localizations.button_eraser;
      case ToolType.FILL:
        return localizations.button_fill;
      case ToolType.HAND:
        return localizations.button_hand;
      case ToolType.IMPORT:
        return localizations.button_import_image;
      case ToolType.LINE:
        return localizations.button_line;
      case ToolType.PIPETTE:
        return localizations.button_pipette;
      case ToolType.SHAPES:
        return localizations.button_shape;
      case ToolType.SMUDGE:
        return localizations.button_smudge;
      case ToolType.SPRAY:
        return localizations.button_spray_can;
      case ToolType.TEXT:
        return localizations.button_text;
      case ToolType.TRANSFORM:
        return localizations.button_transform;
      case ToolType.WATERCOLOR:
        return localizations.button_watercolor;
    }
  }
}
