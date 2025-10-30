import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paintroid/core/tools/implementation/brush_tool.dart';

class WatercolorTool extends BrushTool {
  WatercolorTool({
    required super.commandFactory,
    required super.commandManager,
    required super.graphicFactory,
    required super.type,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = false,
  });

  @override
  void onDown(Offset point, Paint paint) {
    final watercolorPaint = graphicFactory.createWatercolorPaint(paint, 20);
    super.onDown(point, watercolorPaint);
  }
}
