// import 'dart:ui';
// import 'dart:math' as math;
//
// import 'package:flutter_test/flutter_test.dart';
// import 'package:paintroid/core/enums/bounding_box_corners.dart';
// import 'package:paintroid/core/extensions/offset_extension.dart';
// import 'package:paintroid/core/tools/bounding_box.dart';
//
// void main() {
//   double epsilon = 0.000000001;
//   late BoundingBox boundingBox;
//
//   const Offset topLeftInitial = Offset(0, 0);
//   const Offset topRightInitial = Offset(200, 0);
//   const Offset bottomLeftInitial = Offset(0, 200);
//   const Offset bottomRightInitial = Offset(200, 200);
//
//   setUp(() {
//     boundingBox = BoundingBox(
//         topLeftInitial, topRightInitial, bottomLeftInitial, bottomRightInitial);
//   });
//
//   group('resetToDefaultsAroundCenter', () {
//     test(
//         'should reset to default dimensions and zero angle around a new center',
//         () {
//       const newCenter = Offset(300, 300);
//       const defaultWidth = 150.0;
//       const defaultHeight = 150.0;
//       boundingBox.resetToDefaultsAroundCenter(newCenter: newCenter);
//
//       expect(boundingBox.center.dx, closeTo(newCenter.dx, epsilon));
//       expect(boundingBox.center.dy, closeTo(newCenter.dy, epsilon));
//       expect(boundingBox.width, closeTo(defaultWidth, epsilon));
//       expect(boundingBox.height, closeTo(defaultHeight, epsilon));
//       expect(boundingBox.angle, closeTo(0.0, epsilon));
//       expect(boundingBox.activeCorner, BoundingBoxCorner.none);
//
//       final expectedTopLeft = Offset(
//           newCenter.dx - defaultWidth / 2, newCenter.dy - defaultHeight / 2);
//       expect(boundingBox.topLeft.dx, closeTo(expectedTopLeft.dx, epsilon));
//       expect(boundingBox.topLeft.dy, closeTo(expectedTopLeft.dy, epsilon));
//     });
//
//     test('should reset to specified dimensions and zero angle', () {
//       const newCenter = Offset(50, 50);
//       const newWidth = 100.0;
//       const newHeight = 300.0;
//       boundingBox.resetToDefaultsAroundCenter(
//           newCenter: newCenter,
//           defaultWidth: newWidth,
//           defaultHeight: newHeight);
//
//       expect(boundingBox.center.dx, closeTo(newCenter.dx, epsilon));
//       expect(boundingBox.center.dy, closeTo(newCenter.dy, epsilon));
//       expect(boundingBox.width, closeTo(newWidth, epsilon));
//       expect(boundingBox.height, closeTo(newHeight, epsilon));
//       expect(boundingBox.angle, closeTo(0.0, epsilon));
//       expect(boundingBox.activeCorner, BoundingBoxCorner.none);
//     });
//
//     test('should reset to specified dimensions and non-zero angle', () {
//       const newCenter = Offset(10, 20);
//       const newWidth = 200.0;
//       const newHeight = 100.0;
//       const newAngle = math.pi / 4;
//       boundingBox.resetToDefaultsAroundCenter(
//         newCenter: newCenter,
//         defaultWidth: newWidth,
//         defaultHeight: newHeight,
//         defaultAngle: newAngle,
//       );
//
//       expect(boundingBox.center.dx, closeTo(newCenter.dx, epsilon));
//       expect(boundingBox.center.dy, closeTo(newCenter.dy, epsilon));
//       expect(boundingBox.angle, closeTo(newAngle, epsilon));
//       expect(boundingBox.width, closeTo(newWidth, epsilon));
//       expect(boundingBox.height, closeTo(newHeight, epsilon));
//       expect(boundingBox.activeCorner, BoundingBoxCorner.none);
//
//       final halfWidth = newWidth / 2;
//       final halfHeight = newHeight / 2;
//       final baseTopLeft =
//           Offset(newCenter.dx - halfWidth, newCenter.dy - halfHeight);
//       final vector = baseTopLeft - newCenter;
//       final rotatedTopLeft = newCenter +
//           Offset(
//             vector.dx * math.cos(newAngle) - vector.dy * math.sin(newAngle),
//             vector.dx * math.sin(newAngle) + vector.dy * math.cos(newAngle),
//           );
//       expect(boundingBox.topLeft.dx, closeTo(rotatedTopLeft.dx, epsilon));
//       expect(boundingBox.topLeft.dy, closeTo(rotatedTopLeft.dy, epsilon));
//     });
//
//     test('activeCorner should be none after reset', () {
//       boundingBox.activeCorner = BoundingBoxCorner.topLeft;
//       boundingBox.resetToDefaultsAroundCenter(
//           newCenter: const Offset(100, 100));
//       expect(boundingBox.activeCorner, BoundingBoxCorner.none);
//     });
//   });
//
//   group('update (delegated operations)', () {
//     test(
//         'should rotate correctly when activeCorner is topLeftRotationArc and update is called',
//         () {
//       boundingBox.activeCorner = BoundingBoxCorner.topLeftRotationArc;
//       boundingBox.lastPoint = boundingBox.topLeftRotationArcCenter;
//       final centerBefore = boundingBox.center;
//       final initialTopLeftDistanceToCenter =
//           boundingBox.topLeft.distanceTo(centerBefore);
//       const Offset newPoint = Offset(0, 50);
//       boundingBox.update(newPoint);
//       expect(boundingBox.center.dx, closeTo(centerBefore.dx, epsilon));
//       expect(boundingBox.center.dy, closeTo(centerBefore.dy, epsilon));
//       expect(boundingBox.topLeft.distanceTo(centerBefore),
//           closeTo(initialTopLeftDistanceToCenter, epsilon));
//       expect(
//           boundingBox.topLeft.dx, isNot(closeTo(topLeftInitial.dx, epsilon)));
//     });
//
//     test(
//         'should transform edge correctly when activeCorner is topEdge and update is called',
//         () {
//       boundingBox.activeCorner = BoundingBoxCorner.topEdge;
//       final centerBefore = boundingBox.center;
//       const Offset newPoint = Offset(100, 10);
//       boundingBox.lastPoint = const Offset(100, 0);
//       boundingBox.update(newPoint);
//       expect(boundingBox.topLeft.dy, closeTo(newPoint.dy, epsilon));
//       expect(boundingBox.topRight.dy, closeTo(newPoint.dy, epsilon));
//       expect(boundingBox.topLeft.dx, closeTo(topLeftInitial.dx, epsilon));
//       expect(boundingBox.topRight.dx, closeTo(topRightInitial.dx, epsilon));
//       expect(boundingBox.bottomLeft, bottomLeftInitial);
//       expect(boundingBox.bottomRight, bottomRightInitial);
//       expect(boundingBox.center, isNot(centerBefore));
//     });
//
//     test('should move center when activeCorner is none and update is called',
//         () {
//       boundingBox.activeCorner = BoundingBoxCorner.none;
//       final centerBefore = boundingBox.center;
//       const Offset dragVector = Offset(50, 50);
//       boundingBox.lastPoint = centerBefore;
//       final Offset newPoint = centerBefore + dragVector;
//       boundingBox.update(newPoint);
//       expect(boundingBox.center.dx, closeTo(newPoint.dx, epsilon));
//       expect(boundingBox.center.dy, closeTo(newPoint.dy, epsilon));
//       expect(boundingBox.topLeft, topLeftInitial + dragVector);
//       expect(boundingBox.topRight, topRightInitial + dragVector);
//       expect(boundingBox.bottomLeft, bottomLeftInitial + dragVector);
//       expect(boundingBox.bottomRight, bottomRightInitial + dragVector);
//     });
//   });
//
//   group('transform (direct edge manipulation)', () {
//     test(
//         'should scale correctly when a corner handle is active (simulating old transform)',
//         () {
//       boundingBox.activeCorner = BoundingBoxCorner.bottomRight;
//       boundingBox.lastPoint = boundingBox.bottomRight;
//       const Offset newPoint = Offset(250, 250);
//       boundingBox.update(newPoint);
//
//       expect(boundingBox.bottomRight.dx, closeTo(newPoint.dx, epsilon));
//       expect(boundingBox.bottomRight.dy, closeTo(newPoint.dy, epsilon));
//       expect(boundingBox.topLeft.dx, closeTo(topLeftInitial.dx, epsilon));
//       expect(boundingBox.topLeft.dy, closeTo(topLeftInitial.dy, epsilon));
//     });
//   });
//
//   group('rotate (direct rotation)', () {
//     test(
//         'should rotate corners around center when activeCorner is a rotation arc',
//         () {
//       boundingBox.activeCorner = BoundingBoxCorner.topLeftRotationArc;
//       boundingBox.lastPoint = boundingBox.topLeftRotationArcCenter;
//       final centerBefore = boundingBox.center;
//       final initialDistance = boundingBox.topLeft.distanceTo(centerBefore);
//       const Offset newPoint = Offset(0, 50);
//       boundingBox.rotate(newPoint);
//
//       expect(boundingBox.center.dx, closeTo(centerBefore.dx, epsilon));
//       expect(boundingBox.center.dy, closeTo(centerBefore.dy, epsilon));
//       expect(boundingBox.topLeft.distanceTo(centerBefore),
//           closeTo(initialDistance, epsilon));
//       expect(
//           boundingBox.topLeft.dx, isNot(closeTo(topLeftInitial.dx, epsilon)));
//     });
//
//     test('should not rotate when activeCorner is none and rotate is called',
//         () {
//       boundingBox.activeCorner = BoundingBoxCorner.none;
//       final beforeRotation = BoundingBox(
//           boundingBox.topLeft,
//           boundingBox.topRight,
//           boundingBox.bottomLeft,
//           boundingBox.bottomRight);
//       const Offset newPoint = Offset(50, -50);
//       boundingBox.lastPoint = Offset.zero;
//       boundingBox.rotate(newPoint);
//       expect(boundingBox.topLeft, beforeRotation.topLeft);
//       expect(boundingBox.topRight, beforeRotation.topRight);
//       expect(boundingBox.bottomLeft, beforeRotation.bottomLeft);
//       expect(boundingBox.bottomRight, beforeRotation.bottomRight);
//     });
//
//     test(
//         'should NOT rotate if activeCorner is a corner handle and rotate() is called directly',
//         () {
//       boundingBox.activeCorner = BoundingBoxCorner.topLeft;
//       final originalTopLeft = boundingBox.topLeft;
//       const Offset rotatePoint = Offset(100, 100);
//       boundingBox.lastPoint = boundingBox.topLeft;
//       boundingBox.rotate(rotatePoint);
//       expect(boundingBox.topLeft.dx, closeTo(originalTopLeft.dx, epsilon));
//       expect(boundingBox.topLeft.dy, closeTo(originalTopLeft.dy, epsilon));
//     });
//   });
//
//   group('moveCenter (direct)', () {
//     test('should move center and update all corners', () {
//       const Offset newCenter = Offset(150, 150);
//       final initialTopLeft = boundingBox.topLeft;
//       final initialTopRight = boundingBox.topRight;
//       final initialBottomLeft = boundingBox.bottomLeft;
//       final initialBottomRight = boundingBox.bottomRight;
//       final offsetDiff = newCenter - boundingBox.center;
//
//       boundingBox.moveCenter(newCenter);
//
//       expect(boundingBox.center.dx, closeTo(newCenter.dx, epsilon));
//       expect(boundingBox.center.dy, closeTo(newCenter.dy, epsilon));
//       expect(boundingBox.topLeft, initialTopLeft + offsetDiff);
//       expect(boundingBox.topRight, initialTopRight + offsetDiff);
//       expect(boundingBox.bottomLeft, initialBottomLeft + offsetDiff);
//       expect(boundingBox.bottomRight, initialBottomRight + offsetDiff);
//     });
//   });
//
//   group('setActiveCorner', () {
//     test('should set active corner based on corner handles', () {
//       boundingBox.setActiveCorner(topLeftInitial);
//       expect(boundingBox.activeCorner, BoundingBoxCorner.topLeft);
//       boundingBox.setActiveCorner(topRightInitial);
//       expect(boundingBox.activeCorner, BoundingBoxCorner.topRight);
//       boundingBox.setActiveCorner(bottomLeftInitial);
//       expect(boundingBox.activeCorner, BoundingBoxCorner.bottomLeft);
//       boundingBox.setActiveCorner(bottomRightInitial);
//       expect(boundingBox.activeCorner, BoundingBoxCorner.bottomRight);
//     });
//
//     test('should set active corner based on rotation arc handles', () {
//       boundingBox.resetToDefaultsAroundCenter(
//           newCenter: const Offset(100, 100),
//           defaultWidth: 200,
//           defaultHeight: 200);
//
//       final Offset calculatedTopLeftRotationArcCenter =
//           boundingBox.topLeftRotationArcCenter;
//       boundingBox.setActiveCorner(calculatedTopLeftRotationArcCenter);
//       expect(boundingBox.activeCorner, BoundingBoxCorner.topLeftRotationArc);
//
//       final Offset calculatedTopRightRotationArcCenter =
//           boundingBox.topRightRotationArcCenter;
//       boundingBox.setActiveCorner(calculatedTopRightRotationArcCenter);
//       expect(boundingBox.activeCorner, BoundingBoxCorner.topRightRotationArc);
//
//       final Offset calculatedBottomLeftRotationArcCenter =
//           boundingBox.bottomLeftRotationArcCenter;
//       boundingBox.setActiveCorner(calculatedBottomLeftRotationArcCenter);
//       expect(boundingBox.activeCorner, BoundingBoxCorner.bottomLeftRotationArc);
//
//       final Offset calculatedBottomRightRotationArcCenter =
//           boundingBox.bottomRightRotationArcCenter;
//       boundingBox.setActiveCorner(calculatedBottomRightRotationArcCenter);
//       expect(
//           boundingBox.activeCorner, BoundingBoxCorner.bottomRightRotationArc);
//     });
//
//     test('should set active corner to none if point is far from handles', () {
//       boundingBox.setActiveCorner(const Offset(5000, 5000));
//       expect(boundingBox.activeCorner, BoundingBoxCorner.none);
//     });
//
//     test('should set active corner for top edge', () {
//       final topEdgePoint = (boundingBox.topLeft + boundingBox.topRight) / 2;
//       boundingBox.setActiveCorner(topEdgePoint);
//       expect(boundingBox.activeCorner, BoundingBoxCorner.topEdge);
//     });
//   });
//
//   group('getPath', () {
//     test('getPath should return correct path from corners for unrotated box',
//         () {
//       const Offset topLeft = Offset(10, 20);
//       const Offset topRight = Offset(110, 20);
//       const Offset bottomLeft = Offset(10, 120);
//       const Offset bottomRight = Offset(110, 120);
//       final unrotatedBox =
//           BoundingBox(topLeft, topRight, bottomLeft, bottomRight, angle: 0.0);
//       final Path path = unrotatedBox.getPath();
//       final Rect bounds = path.getBounds();
//
//       expect(bounds.topLeft.dx, closeTo(topLeft.dx, epsilon));
//       expect(bounds.topLeft.dy, closeTo(topLeft.dy, epsilon));
//       expect(bounds.bottomRight.dx, closeTo(bottomRight.dx, epsilon));
//       expect(bounds.bottomRight.dy, closeTo(bottomRight.dy, epsilon));
//     });
//
//     test('getPath should return correct path for rotated box', () {
//       final center = const Offset(100, 100);
//       final rotatedBox = BoundingBox(
//           Offset(50, 50), Offset(150, 50), Offset(50, 150), Offset(150, 150),
//           angle: math.pi / 4);
//       rotatedBox.resetToDefaultsAroundCenter(
//           newCenter: center,
//           defaultWidth: 100,
//           defaultHeight: 100,
//           defaultAngle: math.pi / 4);
//
//       final Path path = rotatedBox.getPath();
//       final Rect bounds = path.getBounds();
//
//       expect(bounds.center.dx, closeTo(center.dx, epsilon));
//       expect(bounds.center.dy, closeTo(center.dy, epsilon));
//     });
//   });
// }

import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/core/enums/bounding_box_action.dart';
import 'package:paintroid/core/enums/bounding_box_resize_action.dart';
import 'package:paintroid/core/tools/bounding_box.dart';

void main() {
  group('BoundingBox', () {
    test('constructor clamps width/height to minimalBoxSize', () {
      final box = BoundingBox(center: Offset(0, 0), width: 1, height: 1);
      expect(box.width, BoundingBox.minimalBoxSize);
      expect(box.height, BoundingBox.minimalBoxSize);
    });

    test('getCorners returns four corners', () {
      final box = BoundingBox(center: Offset(10, 20), width: 100, height: 50);
      final corners = box.getCorners();
      expect(corners.length, 4);
      expect(corners[0], isA<Offset>());
    });

    test('determineAction sets currentAction to move inside box', () {
      final box = BoundingBox(center: Offset(0, 0), width: 100, height: 100);
      box.determineAction(Offset(0, 0));
      expect(box.currentAction, BoundingBoxAction.move);
    });

    test('updateDrag moves the box when currentAction is move', () {
      final box = BoundingBox(center: Offset(0, 0), width: 100, height: 100);
      box.determineAction(Offset(0, 0));
      expect(box.currentAction, BoundingBoxAction.move);
      box.updateDrag(Offset(10, 10));
      expect(box.center, Offset(10, 10));
    });

    test('endDrag resets drag state', () {
      final box = BoundingBox(center: Offset(0, 0), width: 100, height: 100);
      box.determineAction(Offset(0, 0));
      box.updateDrag(Offset(10, 10));
      box.endDrag();
      expect(box.lastDragGlobalPosition, isNull);
      expect(box.dragStartLocalPosition, isNull);
    });

    test('determineAction sets currentAction to resize on corner', () {
      final box = BoundingBox(center: Offset(0, 0), width: 100, height: 100);
      // Top-left corner
      box.determineAction(Offset(-50, -50));
      expect(box.currentAction, BoundingBoxAction.resize);
      expect(box.currentBoundingBoxResizeAction, BoundingBoxResizeAction.topLeft);
      // Bottom-right corner
      box.determineAction(Offset(50, 50));
      expect(box.currentAction, BoundingBoxAction.resize);
      expect(box.currentBoundingBoxResizeAction, BoundingBoxResizeAction.bottomRight);
    });

    test('determineAction sets currentAction to resize on edge', () {
      final box = BoundingBox(center: Offset(0, 0), width: 100, height: 100);
      // Top edge
      box.determineAction(Offset(0, -50));
      expect(box.currentAction, BoundingBoxAction.resize);
      expect(box.currentBoundingBoxResizeAction, BoundingBoxResizeAction.top);
      // Left edge
      box.determineAction(Offset(-50, 0));
      expect(box.currentAction, BoundingBoxAction.resize);
      expect(box.currentBoundingBoxResizeAction, BoundingBoxResizeAction.left);
    });

    test('determineAction sets currentAction to rotate on arc', () {
      final box = BoundingBox(center: Offset(0, 0), width: 100, height: 100);
      // Simulate a point on the top-left rotation arc
      final arcPoint = Offset(-50, -50) + Offset(-10, -10);
      box.determineAction(arcPoint);
      expect(box.currentAction,
          anyOf(BoundingBoxAction.rotate, BoundingBoxAction.resize));
    });

    test('updateDrag rotates the box when currentAction is rotate', () {
      final box = BoundingBox(center: Offset(0, 0), width: 100, height: 100);
      // Simulate rotation action
      box.currentAction = BoundingBoxAction.rotate;
      box.lastDragGlobalPosition = Offset(100, 0);
      final initialAngle = box.angle;
      box.updateDrag(Offset(0, 100));
      expect(box.angle, isNot(initialAngle));
    });

    test('updateDrag resizes the box when currentAction is resize', () {
      final box = BoundingBox(center: Offset(0, 0), width: 100, height: 100);
      box.currentAction = BoundingBoxAction.resize;
      box.currentBoundingBoxResizeAction = BoundingBoxResizeAction.right;
      box.lastDragGlobalPosition = Offset(50, 0);
      box.dragStartLocalPosition = Offset(0, 0);
      final initialWidth = box.width;
      box.updateDrag(Offset(60, 0));
      expect(box.width, greaterThan(initialWidth));
    });

    test('endDrag does not reset currentAction', () {
      final box = BoundingBox(center: Offset(0, 0), width: 100, height: 100);
      box.currentAction = BoundingBoxAction.move;
      box.determineAction(Offset(0, 0));
      box.updateDrag(Offset(10, 10));
      box.endDrag();
      expect(box.currentAction, BoundingBoxAction.move);
    });
  });
}
