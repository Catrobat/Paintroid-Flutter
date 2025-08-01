
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
