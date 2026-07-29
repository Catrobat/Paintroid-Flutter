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
        return localizations.buttonBrush;
      case ToolType.CLIPBOARD:
        return localizations.buttonClipboard;
      case ToolType.CLIPPING:
        return localizations.buttonClip;
      case ToolType.CURSOR:
        return localizations.buttonCursor;
      case ToolType.ERASER:
        return localizations.buttonEraser;
      case ToolType.FILL:
        return localizations.buttonFill;
      case ToolType.HAND:
        return localizations.buttonHand;
      case ToolType.IMPORT:
        return localizations.buttonImportImage;
      case ToolType.LINE:
        return localizations.buttonLine;
      case ToolType.PIPETTE:
        return localizations.buttonPipette;
      case ToolType.SHAPES:
        return localizations.buttonShape;
      case ToolType.SMUDGE:
        return localizations.buttonSmudge;
      case ToolType.SPRAY:
        return localizations.buttonSprayCan;
      case ToolType.TEXT:
        return localizations.buttonText;
      case ToolType.TRANSFORM:
        return localizations.buttonTransform;
      case ToolType.WATERCOLOR:
        return localizations.buttonWatercolor;
    }
  }
}
