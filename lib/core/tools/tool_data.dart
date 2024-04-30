// Project imports:
import 'package:paintroid/core/tools/enums/tool_types.dart';

class ToolData {
  final String name;
  final String svgAssetPath;
  final ToolType type;

  const ToolData._(
    this.name,
    this.svgAssetPath,
    this.type,
  );

  static const BRUSH = ToolData._(
    'Brush',
    'assets/svg/ic_brush.svg',
    ToolType.BRUSH,
  );

  static const HAND = ToolData._(
    'Hand',
    'assets/svg/ic_hand.svg',
    ToolType.HAND,
  );

  static const ERASER = ToolData._(
    'Eraser',
    'assets/svg/ic_eraser.svg',
    ToolType.ERASER,
  );

  static const LINE = ToolData._(
    'Line',
    'assets/svg/ic_line.svg',
    ToolType.LINE,
  );

  static const SHAPES = ToolData._(
    'Shapes',
    'assets/svg/ic_shapes.svg',
    ToolType.SHAPES,
  );

  static const FILL = ToolData._(
    'Fill',
    'assets/svg/ic_fill.svg',
    ToolType.FILL,
  );

  static const SPRAY = ToolData._(
    'Spray',
    'assets/svg/ic_spray_can.svg',
    ToolType.SPRAY,
  );

  static const CURSOR = ToolData._(
    'Cursor',
    'assets/svg/ic_cursor.svg',
    ToolType.CURSOR,
  );

  static const TEXT = ToolData._(
    'Text',
    'assets/svg/ic_text.svg',
    ToolType.TEXT,
  );

  static const CLIPBOARD = ToolData._(
    'Clipboard',
    'assets/svg/ic_clipboard.svg',
    ToolType.CLIPBOARD,
  );

  static const TRANSFORM = ToolData._(
    'Transform',
    'assets/svg/ic_transform.svg',
    ToolType.TRANSFORM,
  );

  static const IMPORT = ToolData._(
    'Import',
    'assets/svg/ic_import.svg',
    ToolType.IMPORT,
  );

  static const PIPETTE = ToolData._(
    'Pipette',
    'assets/svg/ic_pipette.svg',
    ToolType.PIPETTE,
  );

  static const WATERCOLOR = ToolData._(
    'Watercolour',
    'assets/svg/ic_watercolor.svg',
    ToolType.WATERCOLOR,
  );

  static const SMUDGE = ToolData._(
    'Smudge',
    'assets/svg/ic_smudge.svg',
    ToolType.SMUDGE,
  );

  static const CLIPPING = ToolData._(
    'Clip area',
    'assets/svg/ic_clipping.svg',
    ToolType.CLIPPING,
  );

  static const allToolsData = [
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
    CLIPPING,
  ];
}
