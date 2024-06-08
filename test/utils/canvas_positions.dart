// Flutter imports:
import 'package:flutter/cupertino.dart';

class CanvasPosition {
  static const int bufferFromEdge = 20;
  static late int canvasWidth;
  static late int canvasHeight;
  static late int centerX;
  static late int centerY;
  static late int left;
  static late int right;
  static late int top;
  static late int bottom;
  static late int halfwayLeft;
  static late int halfwayRight;
  static late int halfwayTop;
  static late int halfwayBottom;
  static late Offset topLeft;
  static late Offset topCenter;
  static late Offset topRight;
  static late Offset halfTopLeft;
  static late Offset halfTopCenter;
  static late Offset halfTopRight;
  static late Offset bottomLeft;
  static late Offset bottomCenter;
  static late Offset bottomRight;
  static late Offset halfBottomLeft;
  static late Offset halfBottomCenter;
  static late Offset halfBottomRight;
  static late Offset centerLeft;
  static late Offset halfCenterLeft;
  static late Offset center;
  static late Offset halfCenterRight;
  static late Offset centerRight;

  static void initializeCanvasDimensions(RenderBox canvasBox) {
    canvasWidth = canvasBox.size.width.toInt();
    canvasHeight = canvasBox.size.height.toInt();
    centerX = canvasWidth ~/ 2;
    centerY = canvasHeight ~/ 2;
    left = bufferFromEdge;
    right = canvasWidth - bufferFromEdge;
    top = bufferFromEdge;
    bottom = canvasHeight - bufferFromEdge;
    halfwayLeft = canvasWidth ~/ 4;
    halfwayRight = 3 * canvasWidth ~/ 4;
    halfwayTop = canvasHeight ~/ 4;
    halfwayBottom = 3 * canvasHeight ~/ 4;
    topLeft = canvasBox.localToGlobal(Offset(left.toDouble(), top.toDouble()));
    topCenter =
        canvasBox.localToGlobal(Offset(centerX.toDouble(), top.toDouble()));
    topRight =
        canvasBox.localToGlobal(Offset(right.toDouble(), top.toDouble()));
    bottomLeft =
        canvasBox.localToGlobal(Offset(left.toDouble(), bottom.toDouble()));
    centerLeft =
        canvasBox.localToGlobal(Offset(left.toDouble(), centerY.toDouble()));
    bottomRight =
        canvasBox.localToGlobal(Offset(right.toDouble(), bottom.toDouble()));
    centerRight =
        canvasBox.localToGlobal(Offset(right.toDouble(), centerY.toDouble()));
    bottomCenter =
        canvasBox.localToGlobal(Offset(centerX.toDouble(), bottom.toDouble()));
    center =
        canvasBox.localToGlobal(Offset(centerX.toDouble(), centerY.toDouble()));
    halfTopLeft = canvasBox
        .localToGlobal(Offset(halfwayLeft.toDouble(), halfwayTop.toDouble()));
    halfTopCenter = canvasBox
        .localToGlobal(Offset(centerX.toDouble(), halfwayTop.toDouble()));
    halfTopRight = canvasBox
        .localToGlobal(Offset(halfwayRight.toDouble(), halfwayTop.toDouble()));
    halfCenterLeft = canvasBox
        .localToGlobal(Offset(halfwayLeft.toDouble(), centerY.toDouble()));
    halfCenterRight = canvasBox
        .localToGlobal(Offset(halfwayRight.toDouble(), centerY.toDouble()));
    halfBottomLeft = canvasBox.localToGlobal(
        Offset(halfwayLeft.toDouble(), halfwayBottom.toDouble()));
    halfBottomRight = canvasBox.localToGlobal(
        Offset(halfwayRight.toDouble(), halfwayBottom.toDouble()));
    halfBottomCenter = canvasBox
        .localToGlobal(Offset(centerX.toDouble(), halfwayBottom.toDouble()));
  }
}
