import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:paintroid/core/commands/command_implementation/command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/clipboard_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/delete_region_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/path_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/spray_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/text_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/ellipse_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/heart_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/square_shape_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/star_shape_command.dart';
import 'package:paintroid/core/commands/path_with_action_history.dart';
import 'package:paintroid/core/enums/shape_style.dart';
import 'package:paintroid/core/models/catrobat_image.dart';
import 'package:paintroid/core/backward_compatibility/models/models.dart';
import 'package:paintroid/core/backward_compatibility/legacy_model_parser.dart';

class LegacyModelTransformer {
  static CatrobatImage transform(LegacyCommandManagerModel model) {
    int width = 800;
    int height = 600;

    // 1. Resolve canvas dimensions from SetDimensionCommand
    final initial = model.initialCommand;
    if (initial is Map && initial['type'] == 'SetDimensionCommand') {
      width = initial['width'] as int;
      height = initial['height'] as int;
    }

    final List<Command> commands = [];

    // 2. Map all native commands
    for (final legacyCmd in model.commands) {
      if (legacyCmd is! Map) continue;

      final type = legacyCmd['type'] as String;
      switch (type) {
        case 'PathCommand':
          final legacyPaint = legacyCmd['paint'] as LegacyPaint;
          final legacyPath = legacyCmd['path'] as LegacySerializablePath;
          commands.add(
            PathCommand(
              _transformPath(legacyPath),
              _transformPaint(legacyPaint),
            ),
          );
          break;

        case 'PointCommand':
          final legacyPaint = legacyCmd['paint'] as LegacyPaint;
          final legacyPoint = legacyCmd['point'] as LegacyPointF;
          final path = PathWithActionHistory();
          path.moveTo(legacyPoint.x, legacyPoint.y);
          path.lineTo(legacyPoint.x, legacyPoint.y);
          commands.add(PathCommand(path, _transformPaint(legacyPaint)));
          break;

        case 'SprayCommand':
          final legacyPaint = legacyCmd['paint'] as LegacyPaint;
          final sprayedPoints = legacyCmd['sprayedPoints'] as List<double>;
          final List<Offset> points = [];
          for (int i = 0; i < sprayedPoints.length - 1; i += 2) {
            points.add(Offset(sprayedPoints[i], sprayedPoints[i + 1]));
          }
          commands.add(SprayCommand(points, _transformPaint(legacyPaint)));
          break;

        case 'TextToolCommand':
          final legacyPaint = legacyCmd['paint'] as LegacyPaint;
          final multilineText = (legacyCmd['multilineText'] as List)
              .cast<String>();
          final position = legacyCmd['position'] as LegacyPointF;
          final rotation = legacyCmd['rotation'] as double;
          final typeface = legacyCmd['typeface'] as LegacySerializableTypeface;

          final text = multilineText.join('\n');
          final point = Offset(position.x, position.y);
          final textStyle = TextStyle(
            color: Color(legacyPaint.color).withAlpha(legacyPaint.alpha),
            fontWeight: typeface.bold ? FontWeight.bold : FontWeight.normal,
            fontStyle: typeface.italic ? FontStyle.italic : FontStyle.normal,
            decoration: typeface.underline
                ? TextDecoration.underline
                : TextDecoration.none,
            fontFamily: _mapFontFamily(typeface.font),
          );

          commands.add(
            TextCommand(
              point,
              text,
              textStyle,
              typeface.textSize,
              _transformPaint(legacyPaint),
              rotationAngle: rotation,
            ),
          );
          break;

        case 'ClipboardCommand':
          final bitmapBytes = legacyCmd['bitmap'] as Uint8List;
          final coordinates = legacyCmd['coordinates'] as LegacyPoint;
          final boxWidth = legacyCmd['width'] as double;
          final rotation = legacyCmd['rotation'] as double;

          final imageWidth = _getPngWidth(bitmapBytes);
          final scale = imageWidth > 0 ? boxWidth / imageWidth : 1.0;
          final offset = Offset(
            coordinates.x.toDouble(),
            coordinates.y.toDouble(),
          );
          final paint = Paint()..color = Colors.black;

          commands.add(
            ClipboardCommand(paint, bitmapBytes, offset, scale, rotation),
          );
          break;

        case 'CutCommand':
          final position = legacyCmd['position'] as LegacyPoint;
          final boxWidth = legacyCmd['boxWidth'] as double;
          final boxHeight = legacyCmd['boxHeight'] as double;

          final left = position.x - boxWidth / 2;
          final top = position.y - boxHeight / 2;
          final region = Rect.fromLTWH(left, top, boxWidth, boxHeight);
          final paint = Paint();

          commands.add(DeleteRegionCommand(paint, region));
          break;

        case 'GeometricFillCommand':
          final legacyPaint = legacyCmd['paint'] as LegacyPaint;
          final shape = legacyCmd['shapeDrawable'] as String;
          final rect = legacyCmd['boxRect'] as LegacyRectF;
          final rotation = legacyCmd['boxRotation'] as double;

          final boxWidth = rect.right - rect.left;
          final boxHeight = rect.bottom - rect.top;
          final center = Offset(
            (rect.left + rect.right) / 2,
            (rect.top + rect.bottom) / 2,
          );
          final paint = _transformPaint(legacyPaint);
          final style = _mapShapeStyle(legacyPaint.style);

          if (shape == 'OvalDrawable') {
            commands.add(
              EllipseShapeCommand(
                paint,
                boxWidth,
                boxHeight,
                center,
                style,
                rotation,
              ),
            );
          } else if (shape == 'RectangleDrawable') {
            final topLeft = _rotateAndShift(
              -boxWidth / 2,
              -boxHeight / 2,
              rotation,
              center,
            );
            final topRight = _rotateAndShift(
              boxWidth / 2,
              -boxHeight / 2,
              rotation,
              center,
            );
            final bottomLeft = _rotateAndShift(
              -boxWidth / 2,
              boxHeight / 2,
              rotation,
              center,
            );
            final bottomRight = _rotateAndShift(
              boxWidth / 2,
              boxHeight / 2,
              rotation,
              center,
            );
            commands.add(
              SquareShapeCommand(
                paint,
                topLeft,
                topRight,
                bottomLeft,
                bottomRight,
                style,
              ),
            );
          } else if (shape == 'HeartDrawable') {
            commands.add(
              HeartShapeCommand(
                paint,
                boxWidth,
                boxHeight,
                rotation,
                center,
                style,
              ),
            );
          } else if (shape == 'StarDrawable') {
            commands.add(
              StarShapeCommand(
                paint,
                5, // Default number of points for legacy star
                rotation,
                center,
                style,
                boxWidth,
                boxHeight,
              ),
            );
          }
          break;

        default:
          break;
      }
    }

    return CatrobatImage(
      commands,
      width,
      height,
      '', // Background image is empty by default for backward compatibility
    );
  }

  static Paint _transformPaint(LegacyPaint legacy) {
    final paint = Paint()
      ..color = Color(legacy.color).withAlpha(legacy.alpha)
      ..strokeWidth = legacy.strokeWidth
      ..strokeCap = StrokeCap.values[legacy.strokeCap]
      ..isAntiAlias = legacy.isAntiAlias
      ..style = PaintingStyle.values[legacy.style]
      ..strokeJoin = StrokeJoin.values[legacy.strokeJoin];

    if (legacy.hadFilter) {
      paint.maskFilter = MaskFilter.blur(
        BlurStyle.inner,
        legacy.alpha.toDouble(),
      );
    }
    return paint;
  }

  static PathWithActionHistory _transformPath(
    LegacySerializablePath legacyPath,
  ) {
    final path = PathWithActionHistory();
    for (final action in legacyPath.actions) {
      if (action is LegacySerializablePathMove) {
        path.moveTo(action.x, action.y);
      } else if (action is LegacySerializablePathLine) {
        path.lineTo(action.x, action.y);
      } else if (action is LegacySerializablePathQuad) {
        path.quadTo(action.x1, action.y1, action.x2, action.y2);
      } else if (action is LegacySerializablePathCube) {
        path.cubicTo(
          action.x1,
          action.y1,
          action.x2,
          action.y2,
          action.x3,
          action.y3,
        );
      } else if (action is LegacySerializablePathRewind) {
        path.close();
      }
    }
    return path;
  }

  static ShapeStyle _mapShapeStyle(int legacyStyle) {
    if (legacyStyle == 0) {
      return ShapeStyle.fill;
    } else {
      return ShapeStyle.outline;
    }
  }

  static String? _mapFontFamily(String font) {
    switch (font) {
      case 'SERIF':
        return 'Serif';
      case 'MONOSPACE':
        return 'Monospace';
      case 'SANS_SERIF':
      default:
        return 'SansSerif';
    }
  }

  static int _getPngWidth(Uint8List pngBytes) {
    if (pngBytes.length < 24) return 0;
    if (pngBytes[0] != 0x89 ||
        pngBytes[1] != 0x50 ||
        pngBytes[2] != 0x4E ||
        pngBytes[3] != 0x47) {
      return 0;
    }
    final byteData = ByteData.sublistView(pngBytes, 16, 20);
    return byteData.getUint32(0, Endian.big);
  }

  static Offset _rotateAndShift(
    double x,
    double y,
    double angle,
    Offset center,
  ) {
    if (angle == 0.0) {
      return Offset(x, y) + center;
    }
    final cosA = math.cos(angle);
    final sinA = math.sin(angle);
    final rx = x * cosA - y * sinA;
    final ry = x * sinA + y * cosA;
    return Offset(rx, ry) + center;
  }
}
