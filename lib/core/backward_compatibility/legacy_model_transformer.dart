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

class LegacyTransformResult {
  final CatrobatImage image;
  final bool hasUnsupportedCommands;

  LegacyTransformResult(this.image, this.hasUnsupportedCommands);
}

class LegacyModelTransformer {
  static LegacyTransformResult transformWithFallback(
    LegacyCommandManagerModel model,
  ) {
    int width = 800;
    int height = 600;
    bool hasUnsupportedCommands = false;

    // 1. Resolve canvas dimensions from SetDimensionCommand
    final initial = model.initialCommand;
    if (initial is Map && initial['type'] == 'SetDimensionCommand') {
      width = initial['width'] as int;
      height = initial['height'] as int;
    }

    final List<Command> commands = [];

    // 2. Map all native commands
    for (final legacyCmd in model.commands) {
      if (legacyCmd is! Map) {
        continue;
      }

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
          final double pointX = (legacyCmd['pointX'] as num).toDouble();
          final double pointY = (legacyCmd['pointY'] as num).toDouble();
          final center = Offset(
            pointX + (rect.left + rect.right) / 2,
            pointY + (rect.top + rect.bottom) / 2,
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

        case 'LoadLayerListCommand':
          final layers = legacyCmd['layers'] as List<dynamic>;
          for (final layer in layers) {
            final bitmapBytes = layer['bitmap'] as Uint8List;
            final opacity = layer['opacity'] as int;

            final scale = 1.0;
            final offset = Offset.zero;
            final paint = Paint()
              ..color = Colors.black.withValues(alpha: opacity / 255.0);

            commands.add(
              ClipboardCommand(paint, bitmapBytes, offset, scale, 0.0),
            );
          }
          break;

        case 'AddEmptyLayerCommand':
        case 'SelectLayerCommand':
        case 'RemoveLayerCommand':
        case 'MergeLayersCommand':
        case 'ReorderLayersCommand':
        case 'LayerOpacityCommand':
          // Safely ignored to flatten multi-layer legacy drawings onto the modern single canvas.
          break;

        case 'RotateCommand':
          final rotateDirection = legacyCmd['rotateDirection'] as int;
          final double oldW = width.toDouble();
          final double oldH = height.toDouble();

          if (rotateDirection == 1) {
            _transformAccumulatedCommands(
              commands,
              (p) => Offset(oldH - p.dy, p.dx),
              swapSize: true,
              mapAngle: (a) => a + math.pi / 2,
            );
            final temp = width;
            width = height;
            height = temp;
          } else if (rotateDirection == 2) {
            _transformAccumulatedCommands(
              commands,
              (p) => Offset(p.dy, oldW - p.dx),
              swapSize: true,
              mapAngle: (a) => a - math.pi / 2,
            );
            final temp = width;
            width = height;
            height = temp;
          }
          break;

        case 'FlipCommand':
          final flipDirection = legacyCmd['flipDirection'] as int;
          final double currentW = width.toDouble();
          final double currentH = height.toDouble();

          if (flipDirection == 1) {
            _transformAccumulatedCommands(
              commands,
              (p) => Offset(currentW - p.dx, p.dy),
              swapSize: false,
              mapAngle: (a) => -a,
            );
          } else if (flipDirection == 2) {
            _transformAccumulatedCommands(
              commands,
              (p) => Offset(p.dx, currentH - p.dy),
              swapSize: false,
              mapAngle: (a) => -a,
            );
          }
          break;

        case 'CropCommand':
          final left = (legacyCmd['coordinateXLeft'] as int).toDouble();
          final top = (legacyCmd['coordinateYTop'] as int).toDouble();
          final right = (legacyCmd['coordinateXRight'] as int).toDouble();
          final bottom = (legacyCmd['coordinateYBottom'] as int).toDouble();

          _transformAccumulatedCommands(
            commands,
            (p) => Offset(p.dx - left, p.dy - top),
            swapSize: false,
            mapAngle: (a) => a,
          );
          width = (right - left).toInt();
          height = (bottom - top).toInt();
          break;

        case 'ResizeCommand':
          final newWidth = legacyCmd['width'] as int;
          final newHeight = legacyCmd['height'] as int;
          final double scaleX = width > 0 ? newWidth / width : 1.0;
          final double scaleY = height > 0 ? newHeight / height : 1.0;

          _transformAccumulatedCommands(
            commands,
            (p) => Offset(p.dx * scaleX, p.dy * scaleY),
            swapSize: false,
            mapAngle: (a) => a,
          );
          width = newWidth;
          height = newHeight;
          break;

        case 'ResetCommand':
          commands.clear();
          break;



        default:
          hasUnsupportedCommands = true;
          break;
      }
    }

    final image = CatrobatImage(
      commands,
      width,
      height,
      '', // Background image is empty by default for backward compatibility
    );

    return LegacyTransformResult(image, hasUnsupportedCommands);
  }

  static CatrobatImage transform(LegacyCommandManagerModel model) {
    return transformWithFallback(model).image;
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

  static void _transformAccumulatedCommands(
    List<Command> commands,
    Offset Function(Offset) mapOffset, {
    required bool swapSize,
    required double Function(double) mapAngle,
  }) {
    for (int i = 0; i < commands.length; i++) {
      final cmd = commands[i];
      if (cmd is PathCommand) {
        commands[i] = PathCommand(
          _transformPathHistory(cmd.path, mapOffset),
          cmd.paint,
        );
      } else if (cmd is SprayCommand) {
        commands[i] = SprayCommand(
          cmd.points.map(mapOffset).toList(),
          cmd.paint,
        );
      } else if (cmd is TextCommand) {
        commands[i] = TextCommand(
          mapOffset(cmd.point),
          cmd.text,
          cmd.style,
          cmd.fontSize,
          cmd.paint,
          rotationAngle: mapAngle(cmd.rotationAngle),
          scaleX: cmd.scaleX,
          scaleY: cmd.scaleY,
          version: cmd.version,
        );
      } else if (cmd is ClipboardCommand) {
        commands[i] = ClipboardCommand(
          cmd.paint,
          cmd.imageData,
          mapOffset(cmd.offset),
          cmd.scale,
          mapAngle(cmd.rotation),
          version: cmd.version,
        );
      } else if (cmd is DeleteRegionCommand) {
        final p1 = mapOffset(cmd.region.topLeft);
        final p2 = mapOffset(cmd.region.bottomRight);
        commands[i] = DeleteRegionCommand(
          cmd.paint,
          Rect.fromPoints(p1, p2),
          version: cmd.version,
        );
      } else if (cmd is EllipseShapeCommand) {
        commands[i] = EllipseShapeCommand(
          cmd.paint,
          swapSize ? cmd.radiusY : cmd.radiusX,
          swapSize ? cmd.radiusX : cmd.radiusY,
          mapOffset(cmd.center),
          cmd.style,
          mapAngle(cmd.angle),
          version: cmd.version,
        );
      } else if (cmd is SquareShapeCommand) {
        commands[i] = SquareShapeCommand(
          cmd.paint,
          mapOffset(cmd.topLeft),
          mapOffset(cmd.topRight),
          mapOffset(cmd.bottomLeft),
          mapOffset(cmd.bottomRight),
          cmd.style,
          version: cmd.version,
        );
      } else if (cmd is HeartShapeCommand) {
        commands[i] = HeartShapeCommand(
          cmd.paint,
          swapSize ? cmd.height : cmd.width,
          swapSize ? cmd.width : cmd.height,
          mapAngle(cmd.angle),
          mapOffset(cmd.center),
          cmd.style,
          version: cmd.version,
        );
      } else if (cmd is StarShapeCommand) {
        commands[i] = StarShapeCommand(
          cmd.paint,
          cmd.numberOfPoints,
          mapAngle(cmd.angle),
          mapOffset(cmd.center),
          cmd.style,
          swapSize ? cmd.radiusY : cmd.radiusX,
          swapSize ? cmd.radiusX : cmd.radiusY,
          version: cmd.version,
        );
      }
    }
  }

  static PathWithActionHistory _transformPathHistory(
    PathWithActionHistory original,
    Offset Function(Offset) mapOffset,
  ) {
    final result = PathWithActionHistory();
    for (final action in original.actions) {
      if (action is MoveToAction) {
        final p = mapOffset(Offset(action.x, action.y));
        result.moveTo(p.dx, p.dy);
      } else if (action is LineToAction) {
        final p = mapOffset(Offset(action.x, action.y));
        result.lineTo(p.dx, p.dy);
      } else if (action is CloseAction) {
        result.close();
      } else if (action is QuadToAction) {
        final p1 = mapOffset(Offset(action.x1, action.y1));
        final p2 = mapOffset(Offset(action.x2, action.y2));
        result.quadTo(p1.dx, p1.dy, p2.dx, p2.dy);
      } else if (action is CubicToAction) {
        final p1 = mapOffset(Offset(action.x1, action.y1));
        final p2 = mapOffset(Offset(action.x2, action.y2));
        final p3 = mapOffset(Offset(action.x3, action.y3));
        result.cubicTo(p1.dx, p1.dy, p2.dx, p2.dy, p3.dx, p3.dy);
      }
    }
    return result;
  }
}
