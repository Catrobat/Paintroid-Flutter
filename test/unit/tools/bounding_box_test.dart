import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/enums/bounding_box_corners.dart';
import 'package:paintroid/core/extensions/offset_extension.dart';
import 'package:paintroid/core/tools/bounding_box.dart';

void main() {
  double epsilon = 0.000000001;
  late BoundingBox boundingBox;

  const Offset topLeftInitial = Offset(0, 0);
  const Offset topRightInitial = Offset(200, 0);
  const Offset bottomLeftInitial = Offset(0, 200);
  const Offset bottomRightInitial = Offset(200, 200);

  setUp(() {
    boundingBox = BoundingBox(
        topLeftInitial, topRightInitial, bottomLeftInitial, bottomRightInitial);
  });

  group('update (delegated operations)', () {
    test(
        'should rotate correctly when activeCorner is topLeftRotationArc and update is called',
        () {
      boundingBox.activeCorner = BoundingBoxCorner.topLeftRotationArc;
      final centerBefore = boundingBox.center;
      final initialTopLeftDistanceToCenter =
          boundingBox.topLeft.distanceTo(centerBefore);
      const Offset newPoint = Offset(0, 50);
      boundingBox.lastPoint = boundingBox.topLeftRotationArcCenter;
      boundingBox.update(newPoint);
      expect(boundingBox.center.dx, closeTo(centerBefore.dx, epsilon));
      expect(boundingBox.center.dy, closeTo(centerBefore.dy, epsilon));
      expect(boundingBox.topLeft.distanceTo(centerBefore),
          closeTo(initialTopLeftDistanceToCenter, epsilon));
      expect(
          boundingBox.topLeft.dx, isNot(closeTo(topLeftInitial.dx, epsilon)));
    });

    test(
        'should transform edge correctly when activeCorner is topEdge and update is called',
        () {
      boundingBox.activeCorner = BoundingBoxCorner.topEdge;
      final centerBefore = boundingBox.center;
      const Offset newPoint = Offset(100, 10);
      boundingBox.lastPoint = const Offset(100, 0);
      boundingBox.update(newPoint);
      expect(boundingBox.topLeft.dy, closeTo(newPoint.dy, epsilon));
      expect(boundingBox.topRight.dy, closeTo(newPoint.dy, epsilon));
      expect(boundingBox.topLeft.dx, closeTo(topLeftInitial.dx, epsilon));
      expect(boundingBox.topRight.dx, closeTo(topRightInitial.dx, epsilon));
      expect(boundingBox.bottomLeft, bottomLeftInitial);
      expect(boundingBox.bottomRight, bottomRightInitial);
      expect(boundingBox.center, isNot(centerBefore));
    });

    test('should move center when activeCorner is none and update is called',
        () {
      boundingBox.activeCorner = BoundingBoxCorner.none;
      final centerBefore = boundingBox.center;
      const Offset dragVector = Offset(50, 50);
      boundingBox.lastPoint = centerBefore;
      final Offset newPoint = centerBefore + dragVector;
      boundingBox.update(newPoint);
      expect(boundingBox.center.dx, closeTo(newPoint.dx, epsilon));
      expect(boundingBox.center.dy, closeTo(newPoint.dy, epsilon));
      expect(boundingBox.topLeft, topLeftInitial + dragVector);
      expect(boundingBox.topRight, topRightInitial + dragVector);
      expect(boundingBox.bottomLeft, bottomLeftInitial + dragVector);
      expect(boundingBox.bottomRight, bottomRightInitial + dragVector);
    });
  });

  group('transform (direct edge manipulation)', () {
    test('should update top edge when dragging', () {
      boundingBox.activeCorner = BoundingBoxCorner.topEdge;
      final centerBefore = boundingBox.center;
      const Offset newPoint = Offset(100, 10);
      boundingBox.lastPoint = const Offset(100, 0);
      boundingBox.transform(newPoint);
      expect(boundingBox.topLeft.dy, closeTo(newPoint.dy, epsilon));
      expect(boundingBox.topRight.dy, closeTo(newPoint.dy, epsilon));
      expect(boundingBox.topLeft.dx, closeTo(topLeftInitial.dx, epsilon));
      expect(boundingBox.topRight.dx, closeTo(topRightInitial.dx, epsilon));
      expect(boundingBox.bottomLeft, bottomLeftInitial);
      expect(boundingBox.bottomRight, bottomRightInitial);
      expect(boundingBox.center, isNot(centerBefore));
    });

    test('should update bottom edge when dragging', () {
      boundingBox.activeCorner = BoundingBoxCorner.bottomEdge;
      final centerBefore = boundingBox.center;
      const Offset newPoint = Offset(100, 190);
      boundingBox.lastPoint = const Offset(100, 200);
      boundingBox.transform(newPoint);
      expect(boundingBox.bottomLeft.dy, closeTo(newPoint.dy, epsilon));
      expect(boundingBox.bottomRight.dy, closeTo(newPoint.dy, epsilon));
      expect(boundingBox.bottomLeft.dx, closeTo(bottomLeftInitial.dx, epsilon));
      expect(
          boundingBox.bottomRight.dx, closeTo(bottomRightInitial.dx, epsilon));
      expect(boundingBox.topLeft, topLeftInitial);
      expect(boundingBox.topRight, topRightInitial);
      expect(boundingBox.center, isNot(centerBefore));
    });

    test('should update left edge when dragging', () {
      boundingBox.activeCorner = BoundingBoxCorner.leftEdge;
      final centerBefore = boundingBox.center;
      const Offset newPoint = Offset(10, 100);
      boundingBox.lastPoint = const Offset(0, 100);
      boundingBox.transform(newPoint);
      expect(boundingBox.topLeft.dx, closeTo(newPoint.dx, epsilon));
      expect(boundingBox.bottomLeft.dx, closeTo(newPoint.dx, epsilon));
      expect(boundingBox.topLeft.dy, closeTo(topLeftInitial.dy, epsilon));
      expect(boundingBox.bottomLeft.dy, closeTo(bottomLeftInitial.dy, epsilon));
      expect(boundingBox.topRight, topRightInitial);
      expect(boundingBox.bottomRight, bottomRightInitial);
      expect(boundingBox.center, isNot(centerBefore));
    });

    test('should update right edge when dragging', () {
      boundingBox.activeCorner = BoundingBoxCorner.rightEdge;
      final centerBefore = boundingBox.center;
      const Offset newPoint = Offset(190, 100);
      boundingBox.lastPoint = const Offset(200, 100);
      boundingBox.transform(newPoint);
      expect(boundingBox.topRight.dx, closeTo(newPoint.dx, epsilon));
      expect(boundingBox.bottomRight.dx, closeTo(newPoint.dx, epsilon));
      expect(boundingBox.topRight.dy, closeTo(topRightInitial.dy, epsilon));
      expect(
          boundingBox.bottomRight.dy, closeTo(bottomRightInitial.dy, epsilon));
      expect(boundingBox.topLeft, topLeftInitial);
      expect(boundingBox.bottomLeft, bottomLeftInitial);
      expect(boundingBox.center, isNot(centerBefore));
    });
  });

  group('rotate (direct rotation)', () {
    test(
        'should rotate corners around center when activeCorner is a rotation arc',
        () {
      boundingBox.activeCorner = BoundingBoxCorner.topLeftRotationArc;
      final centerBefore = boundingBox.center;
      final initialDistance = boundingBox.topLeft.distanceTo(centerBefore);
      const Offset newPoint = Offset(50, -50);
      boundingBox.lastPoint = boundingBox.topLeftRotationArcCenter;
      boundingBox.rotate(newPoint);
      expect(boundingBox.center.dx, closeTo(centerBefore.dx, epsilon));
      expect(boundingBox.center.dy, closeTo(centerBefore.dy, epsilon));
      expect(boundingBox.topLeft.distanceTo(centerBefore),
          closeTo(initialDistance, epsilon));
      expect(
          boundingBox.topLeft.dx, isNot(closeTo(topLeftInitial.dx, epsilon)));
    });

    test('should not rotate when activeCorner is none and rotate is called',
        () {
      boundingBox.activeCorner = BoundingBoxCorner.none;
      final beforeRotation = BoundingBox(
          boundingBox.topLeft,
          boundingBox.topRight,
          boundingBox.bottomLeft,
          boundingBox.bottomRight);
      const Offset newPoint = Offset(50, -50);
      boundingBox.lastPoint = Offset.zero;
      boundingBox.rotate(newPoint);
      expect(boundingBox.topLeft, beforeRotation.topLeft);
      expect(boundingBox.topRight, beforeRotation.topRight);
      expect(boundingBox.bottomLeft, beforeRotation.bottomLeft);
      expect(boundingBox.bottomRight, beforeRotation.bottomRight);
    });

    test(
        'should rotate based on activeCorner direction if it s a corner handle (specific rotate() behavior)',
        () {
      boundingBox.activeCorner = BoundingBoxCorner.topLeft;
      final centerBefore = boundingBox.center;
      const Offset rotatePoint = Offset(100, 100);
      boundingBox.lastPoint = boundingBox.topLeft;
      boundingBox.rotate(rotatePoint);
      expect(
          boundingBox.topLeft.dx, isNot(closeTo(topLeftInitial.dx, epsilon)));
      expect(
          boundingBox.topLeft.dy, isNot(closeTo(topLeftInitial.dy, epsilon)));
      expect(boundingBox.center.dx, closeTo(centerBefore.dx, epsilon));
      expect(boundingBox.center.dy, closeTo(centerBefore.dy, epsilon));
    });
  });

  group('moveCenter (direct)', () {
    test('should move center and update all corners', () {
      const Offset newCenter = Offset(150, 150);
      final offsetDiff = newCenter - boundingBox.center;
      boundingBox.moveCenter(newCenter);
      expect(boundingBox.center.dx, closeTo(newCenter.dx, epsilon));
      expect(boundingBox.center.dy, closeTo(newCenter.dy, epsilon));
      expect(boundingBox.topLeft, topLeftInitial + offsetDiff);
      expect(boundingBox.topRight, topRightInitial + offsetDiff);
      expect(boundingBox.bottomLeft, bottomLeftInitial + offsetDiff);
      expect(boundingBox.bottomRight, bottomRightInitial + offsetDiff);
    });
  });

  group('setActiveCorner', () {
    test('should set active corner based on corner handles', () {
      boundingBox.setActiveCorner(topLeftInitial);
      expect(boundingBox.activeCorner, BoundingBoxCorner.topLeft);
      boundingBox.setActiveCorner(topRightInitial);
      expect(boundingBox.activeCorner, BoundingBoxCorner.topRight);
      boundingBox.setActiveCorner(bottomLeftInitial);
      expect(boundingBox.activeCorner, BoundingBoxCorner.bottomLeft);
      boundingBox.setActiveCorner(bottomRightInitial);
      expect(boundingBox.activeCorner, BoundingBoxCorner.bottomRight);
    });

    test('should set active corner based on rotation arc handles', () {
      final Offset calculatedTopLeftRotationArcCenter = boundingBox.topLeft
          .move(boundingBox.rotationArcOffset,
              (boundingBox.topLeft - boundingBox.center).direction);
      boundingBox.setActiveCorner(calculatedTopLeftRotationArcCenter);
      expect(boundingBox.activeCorner, BoundingBoxCorner.topLeftRotationArc);
      final Offset calculatedTopRightRotationArcCenter = boundingBox.topRight
          .move(boundingBox.rotationArcOffset,
              (boundingBox.topRight - boundingBox.center).direction);
      boundingBox.setActiveCorner(calculatedTopRightRotationArcCenter);
      expect(boundingBox.activeCorner, BoundingBoxCorner.topRightRotationArc);
      final Offset calculatedBottomLeftRotationArcCenter =
          boundingBox.bottomLeft.move(boundingBox.rotationArcOffset,
              (boundingBox.bottomLeft - boundingBox.center).direction);
      boundingBox.setActiveCorner(calculatedBottomLeftRotationArcCenter);
      expect(boundingBox.activeCorner, BoundingBoxCorner.bottomLeftRotationArc);
      final Offset calculatedBottomRightRotationArcCenter =
          boundingBox.bottomRight.move(boundingBox.rotationArcOffset,
              (boundingBox.bottomRight - boundingBox.center).direction);
      boundingBox.setActiveCorner(calculatedBottomRightRotationArcCenter);
      expect(
          boundingBox.activeCorner, BoundingBoxCorner.bottomRightRotationArc);
    });
    test('should set active corner to none if point is far from handles', () {
      boundingBox.setActiveCorner(const Offset(500, 500));
      expect(boundingBox.activeCorner, BoundingBoxCorner.none);
    });

    test('should set active corner for top edge', () {
      final topEdgePoint =
          (topLeftInitial + topRightInitial) / 2 + const Offset(0, 1);
      boundingBox.setActiveCorner(topEdgePoint);
      expect(boundingBox.activeCorner, BoundingBoxCorner.topEdge);
    });
  });

  group('getPath', () {
    test('getPath should return correct path from corners', () {
      const Offset topLeft = Offset(0, 0);
      const Offset topRight = Offset(100, 0);
      const Offset bottomRight = Offset(100, 100);
      const Offset bottomLeft = Offset(0, 100);
      final boundingBox =
          BoundingBox(topLeft, topRight, bottomLeft, bottomRight);
      final Path path = boundingBox.getPath();
      final List<Offset> extractedPoints = [];
      for (final metric in path.computeMetrics()) {
        final extract = metric.extractPath(0, metric.length);
        for (double distance = 0.0;
            distance <= metric.length;
            distance += 1.0) {
          extractedPoints.add(extract
              .computeMetrics()
              .first
              .getTangentForOffset(distance)!
              .position);
        }
      }
      expect(path.getBounds().topLeft, topLeft);
      expect(path.getBounds().bottomRight, bottomRight);
    });
  });
}
