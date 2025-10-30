import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/enums/shape_style.dart';
import 'package:path_drawing/path_drawing.dart' as path_drawing;

class ShapeDrawingUtils {
  static void drawPathWithStyle({
    required Canvas canvas,
    required Path path,
    required Paint basePaint,
    required ShapeStyle style,
  }) {
    final fillPaint = GraphicFactory.createFillPaint(basePaint);
    final strokePaint = GraphicFactory.createStrokePaint(basePaint);

    final double currentStrokeWidth = basePaint.strokeWidth;

    final double dashMultiplier = 6.0;
    final double gapMultiplier = 1.5;
    final double minSegmentLength = 3.0;

    final double effectiveSqrtStrokeWidth =
        math.sqrt(math.max(0.0, currentStrokeWidth));

    final double dynamicDashLength =
        math.max(minSegmentLength, dashMultiplier * effectiveSqrtStrokeWidth);
    final double dynamicGapLength =
        math.max(minSegmentLength, gapMultiplier * effectiveSqrtStrokeWidth);

    final dashArray = path_drawing.CircularIntervalList<double>(
        [dynamicDashLength, dynamicGapLength]);

    switch (style) {
      case ShapeStyle.fill:
        final closedPath = Path()
          ..addPath(path, Offset.zero)
          ..close();
        canvas.drawPath(closedPath, fillPaint);
        canvas.drawPath(closedPath, strokePaint);
        break;
      case ShapeStyle.outline:
        canvas.drawPath(path, strokePaint);
        break;
      case ShapeStyle.dashed:
        final dashedPath = path_drawing.dashPath(path, dashArray: dashArray);
        canvas.drawPath(dashedPath, strokePaint);
        break;
      case ShapeStyle.fillAndDashed:
        final closedPath = Path()
          ..addPath(path, Offset.zero)
          ..close();
        canvas.drawPath(closedPath, fillPaint);
        final dashedOutline =
            path_drawing.dashPath(closedPath, dashArray: dashArray);
        canvas.drawPath(dashedOutline, strokePaint);
        break;
    }
  }
}
