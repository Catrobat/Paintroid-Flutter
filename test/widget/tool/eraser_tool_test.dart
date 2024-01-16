import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:paintroid/service/device_service.dart';
import 'package:paintroid/tool/tool.dart';
import 'package:paintroid/ui/pocket_paint.dart';

import '../utils/utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Pixel value changes after drawing and erasing',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            IDeviceService.sizeProvider
                .overrideWith((ref) => Future.value(const Size(600, 600)))
          ],
          child: const MaterialApp(
            home: PocketPaint(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final canvasInteractions = CanvasInteractions(tester);
      final bottomNavBarInteractions = BottomNavBarInteractions(tester);

      const testOffset = Offset(10, 10);

      final pixelColorBeforeErase = await canvasInteractions
          .dragFromCenter(testOffset)
          .then((_) => canvasInteractions.getPixelColor(300, 300));
      expect(pixelColorBeforeErase, isNot(equals(0)));

      await bottomNavBarInteractions.selectTool(ToolData.ERASER);

      final pixelColorAfterErase = await canvasInteractions
          .dragFromCenter(testOffset)
          .then((_) => canvasInteractions.getPixelColor(300, 300));
      expect(pixelColorAfterErase, equals(0));
    },
  );
}
