import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/enums/bounding_box_corners.dart';
import 'package:paintroid/core/tools/implementation/shapes_tool/bounding_box.dart';

void main() {
  double epsilon = 0.000000001;
  late BoundingBox boundingBox;

  const Offset topLeft = Offset(0, 0);
  const Offset topRight = Offset(200, 0);
  const Offset bottomLeft = Offset(0, 200);
  const Offset bottomRight = Offset(200, 200);

  setUp(() =>
      boundingBox = BoundingBox(topLeft, topRight, bottomLeft, bottomRight));

  group('transform', () {
    test('should update topLeft, topRight and bottomLeft corners only', () {
      boundingBox.activeCorner = BoundingBoxCorner.topLeft;
      final centerBefore = boundingBox.center;
      const Offset newPoint = Offset(10, 10);
      boundingBox.transform(newPoint);
      expect(boundingBox.topLeft, newPoint);
      expect(boundingBox.bottomLeft.dx, closeTo(newPoint.dx, epsilon));
      expect(boundingBox.bottomLeft.dy, closeTo(bottomLeft.dy, epsilon));
      expect(boundingBox.topRight.dx, closeTo(topRight.dx, epsilon));
      expect(boundingBox.topRight.dy, closeTo(newPoint.dy, epsilon));
      expect(boundingBox.bottomRight, bottomRight);
      expect(boundingBox.center, isNot(centerBefore));
    });

    test('should update topRight, topLeft and bottomRight corners only', () {
      boundingBox.activeCorner = BoundingBoxCorner.topRight;
      final centerBefore = boundingBox.center;
      const Offset newPoint = Offset(190, 10);
      boundingBox.transform(newPoint);
      expect(boundingBox.topRight, newPoint);
      expect(boundingBox.bottomRight.dx, closeTo(newPoint.dx, epsilon));
      expect(boundingBox.bottomRight.dy, closeTo(bottomRight.dy, epsilon));
      expect(boundingBox.topLeft.dx, closeTo(topLeft.dx, epsilon));
      expect(boundingBox.topLeft.dy, closeTo(newPoint.dy, epsilon));
      expect(boundingBox.bottomLeft, bottomLeft);
      expect(boundingBox.center, isNot(centerBefore));
    });

    test('should update bottomLeft, topLeft and bottomRight corners only', () {
      boundingBox.activeCorner = BoundingBoxCorner.bottomLeft;
      final centerBefore = boundingBox.center;
      const Offset newPoint = Offset(10, 190);
      boundingBox.transform(newPoint);
      expect(boundingBox.bottomLeft, newPoint);
      expect(boundingBox.topLeft.dx, closeTo(newPoint.dx, epsilon));
      expect(boundingBox.topLeft.dy, closeTo(topLeft.dy, epsilon));
      expect(boundingBox.bottomRight.dx, closeTo(bottomRight.dx, epsilon));
      expect(boundingBox.bottomRight.dy, closeTo(newPoint.dy, epsilon));
      expect(boundingBox.topRight, topRight);
      expect(boundingBox.center, isNot(centerBefore));
    });

    test('should update bottomRight, topRight and bottomLeft corners only', () {
      boundingBox.activeCorner = BoundingBoxCorner.bottomRight;
      final centerBefore = boundingBox.center;
      const Offset newPoint = Offset(190, 190);
      boundingBox.transform(newPoint);
      expect(boundingBox.bottomRight, newPoint);
      expect(boundingBox.topRight.dx, closeTo(newPoint.dx, epsilon));
      expect(boundingBox.topRight.dy, closeTo(topRight.dy, epsilon));
      expect(boundingBox.bottomLeft.dx, closeTo(bottomLeft.dx, epsilon));
      expect(boundingBox.bottomLeft.dy, closeTo(newPoint.dy, epsilon));
      expect(boundingBox.topLeft, topLeft);
      expect(boundingBox.center, isNot(centerBefore));
    });

    test('should not update corner when activeCorner is none', () {
      boundingBox.activeCorner = BoundingBoxCorner.none;
      const Offset newPoint = Offset(300, 300);
      boundingBox.transform(newPoint);
      expect(boundingBox.topLeft, topLeft);
      expect(boundingBox.topRight, topRight);
      expect(boundingBox.bottomLeft, bottomLeft);
      expect(boundingBox.bottomRight, bottomRight);
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
      expect(boundingBox.topLeft.dx, isNot(topLeft.dx));
      expect(boundingBox.topLeft.dy, isNot(topLeft.dy));
      expect(boundingBox.center, centerBefore);
    });
  });

  group('setActiveCorner', () {
    test('should set active corner to topLeft', () {
      boundingBox.setActiveCorner(topLeft);
      expect(boundingBox.activeCorner, BoundingBoxCorner.topLeft);
    });

    test('should set active corner to topRight', () {
      boundingBox.setActiveCorner(topRight);
      expect(boundingBox.activeCorner, BoundingBoxCorner.topRight);
    });

    test('should set active corner to bottomLeft', () {
      boundingBox.setActiveCorner(bottomLeft);
      expect(boundingBox.activeCorner, BoundingBoxCorner.bottomLeft);
    });

    test('should set active corner to bottomRight', () {
      boundingBox.setActiveCorner(bottomRight);
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
      final oldCenter = boundingBox.center;
      boundingBox.activeCorner = BoundingBoxCorner.none;
      boundingBox.update(newCenter);
      expect(boundingBox.center, isNot(oldCenter));
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
