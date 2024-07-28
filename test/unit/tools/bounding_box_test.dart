import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/enums/bounding_box_corners.dart';
import 'package:paintroid/core/tools/implementation/shapes_tool/bounding_box.dart';

void main() {
  double epsilon = 0.000000001;
  late BoundingBox boundingBox;

  const Offset pointA = Offset(0, 0);
  const Offset pointB = Offset(200, 0);
  const Offset pointC = Offset(0, 200);
  const Offset pointD = Offset(200, 200);

  setUp(() => boundingBox = BoundingBox(pointA, pointB, pointC, pointD));

  group('transform', () {
    test('should update topLeft, topRight and bottomLeft corners only', () {
      boundingBox.activeCorner = BoundingBoxCorner.topLeft;
      final centerBefore = boundingBox.center;
      const Offset newPoint = Offset(10, 10);
      boundingBox.transform(newPoint);
      expect(boundingBox.topLeft, newPoint);
      expect(boundingBox.bottomLeft.dx, closeTo(newPoint.dx, epsilon));
      expect(boundingBox.bottomLeft.dy, closeTo(pointC.dy, epsilon));
      expect(boundingBox.topRight.dx, closeTo(pointB.dx, epsilon));
      expect(boundingBox.topRight.dy, closeTo(newPoint.dy, epsilon));
      expect(boundingBox.bottomRight, pointD);
      expect(boundingBox.center, isNot(centerBefore));
    });

    test('should update topRight, topLeft and bottomRight corners only', () {
      boundingBox.activeCorner = BoundingBoxCorner.topRight;
      final centerBefore = boundingBox.center;
      const Offset newPoint = Offset(190, 10);
      boundingBox.transform(newPoint);
      expect(boundingBox.topRight, newPoint);
      expect(boundingBox.bottomRight.dx, closeTo(newPoint.dx, epsilon));
      expect(boundingBox.bottomRight.dy, closeTo(pointD.dy, epsilon));
      expect(boundingBox.topLeft.dx, closeTo(pointA.dx, epsilon));
      expect(boundingBox.topLeft.dy, closeTo(newPoint.dy, epsilon));
      expect(boundingBox.bottomLeft, pointC);
      expect(boundingBox.center, isNot(centerBefore));
    });

    test('should update bottomLeft, topLeft and bottomRight corners only', () {
      boundingBox.activeCorner = BoundingBoxCorner.bottomLeft;
      final centerBefore = boundingBox.center;
      const Offset newPoint = Offset(10, 190);
      boundingBox.transform(newPoint);
      expect(boundingBox.bottomLeft, newPoint);
      expect(boundingBox.topLeft.dx, closeTo(newPoint.dx, epsilon));
      expect(boundingBox.topLeft.dy, closeTo(pointA.dy, epsilon));
      expect(boundingBox.bottomRight.dx, closeTo(pointD.dx, epsilon));
      expect(boundingBox.bottomRight.dy, closeTo(newPoint.dy, epsilon));
      expect(boundingBox.topRight, pointB);
      expect(boundingBox.center, isNot(centerBefore));
    });

    test('should update bottomRight, topRight and bottomLeft corners only', () {
      boundingBox.activeCorner = BoundingBoxCorner.bottomRight;
      final centerBefore = boundingBox.center;
      const Offset newPoint = Offset(190, 190);
      boundingBox.transform(newPoint);
      expect(boundingBox.bottomRight, newPoint);
      expect(boundingBox.topRight.dx, closeTo(newPoint.dx, epsilon));
      expect(boundingBox.topRight.dy, closeTo(pointB.dy, epsilon));
      expect(boundingBox.bottomLeft.dx, closeTo(pointC.dx, epsilon));
      expect(boundingBox.bottomLeft.dy, closeTo(newPoint.dy, epsilon));
      expect(boundingBox.topLeft, pointA);
      expect(boundingBox.center, isNot(centerBefore));
    });

    test('should not update corner when activeCorner is none', () {
      boundingBox.activeCorner = BoundingBoxCorner.none;
      const Offset newPoint = Offset(300, 300);
      boundingBox.transform(newPoint);
      expect(boundingBox.topLeft, pointA);
      expect(boundingBox.topRight, pointB);
      expect(boundingBox.bottomLeft, pointC);
      expect(boundingBox.bottomRight, pointD);
    });
  });

  group('moveCenter', () {
    test('should move center', () {
      const Offset newCenter = Offset(150, 150);
      boundingBox.moveCenter(newCenter);
      expect(boundingBox.center, newCenter);
    });
  });

  group('rotate', () {
    test('should rotate only the bounding box', () {
      boundingBox.activeCorner = BoundingBoxCorner.topLeft;
      final centerBefore = boundingBox.center;
      const Offset rotatePoint = Offset(100, 100);
      boundingBox.rotate(rotatePoint);
      expect(boundingBox.topLeft.dx, isNot(pointA.dx));
      expect(boundingBox.topLeft.dy, isNot(pointA.dy));
      expect(boundingBox.center, centerBefore);
    });
  });

  group('setActiveCorner', () {
    test('should set active corner to topLeft', () {
      boundingBox.setActiveCorner(pointA);
      expect(boundingBox.activeCorner, BoundingBoxCorner.topLeft);
    });

    test('should set active corner to topRight', () {
      boundingBox.setActiveCorner(pointB);
      expect(boundingBox.activeCorner, BoundingBoxCorner.topRight);
    });

    test('should set active corner to bottomLeft', () {
      boundingBox.setActiveCorner(pointC);
      expect(boundingBox.activeCorner, BoundingBoxCorner.bottomLeft);
    });

    test('should set active corner to bottomRight', () {
      boundingBox.setActiveCorner(pointD);
      expect(boundingBox.activeCorner, BoundingBoxCorner.bottomRight);
    });

    test('should set active corner to none', () {
      boundingBox.setActiveCorner(const Offset(100, 100));
      expect(boundingBox.activeCorner, BoundingBoxCorner.none);
    });
  });

  group('resetActiveCorner', () {
    test('should reset active corner', () {
      boundingBox.activeCorner = BoundingBoxCorner.topLeft;
      boundingBox.resetActiveCorner();
      expect(boundingBox.activeCorner, BoundingBoxCorner.none);
    });
  });

  group('update', () {
    test('should move center when activeCorner is none', () {
      const Offset newCenter = Offset(500, 500);
      boundingBox.activeCorner = BoundingBoxCorner.none;
      boundingBox.update(newCenter);
      expect(boundingBox.center, newCenter);
    });

    test('should rotate only activeCorner when isRotating is true', () {
      boundingBox.activeCorner = BoundingBoxCorner.topLeft;
      final centerBefore = boundingBox.center;
      const Offset newPoint = Offset(300, 300);
      boundingBox.update(newPoint, isRotating: true);
      expect(boundingBox.topLeft, isNot(newPoint));
      expect(boundingBox.center, centerBefore);
    });

    test('should transform activeCorner when isRotating is false', () {
      boundingBox.activeCorner = BoundingBoxCorner.topRight;
      final centerBefore = boundingBox.center;
      const Offset newPoint = Offset(300, 300);
      boundingBox.update(newPoint, isRotating: false);
      expect(boundingBox.topRight, newPoint);
      expect(boundingBox.center, isNot(centerBefore));
    });
  });
}
