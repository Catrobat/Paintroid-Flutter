import 'package:flutter/widgets.dart';

import 'package:flutter_test/flutter_test.dart';

class InterActiveViewerInteractions {
  InterActiveViewerInteractions(this._tester);

  double epsilon = 0.1;

  final WidgetTester _tester;

  Future<InterActiveViewerInteractions> panAndVerify(Offset offset) async {
    final finder = find.byType(InteractiveViewer);

    expect(finder, findsOneWidget);

    InteractiveViewer interactiveViewer = _tester.widget(finder);

    TransformationController controller =
        interactiveViewer.transformationController!;

    expect(controller, isNotNull);

    final initialMatrix = controller.value;

    await _tester.drag(finder, offset);
    await _tester.pumpAndSettle();

    double expectedX = initialMatrix.getTranslation().x + offset.dx;
    double expectedY = initialMatrix.getTranslation().y + offset.dy;

    expect(controller.value.getTranslation().x, closeTo(expectedX, epsilon));
    expect(controller.value.getTranslation().y, closeTo(expectedY, epsilon));
    return this;
  }
}
