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

    await _tester.drag(finder, const Offset(-50, 50));
    await _tester.pumpAndSettle();

    double expectedX = initialMatrix.getTranslation().x - 50;
    double expectedY = initialMatrix.getTranslation().y + 50;

    expect(controller.value.getTranslation().x, closeTo(expectedX, epsilon));
    expect(controller.value.getTranslation().y, closeTo(expectedY, epsilon));
    return this;
  }
}
