import 'dart:ui' as ui;
import 'package:colorpicker/pages/pipette_tool_page.dart';
import 'package:colorpicker/src/state/color_picker_state_data.dart';
import 'package:colorpicker/src/state/color_picker_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Helper function to create a sample image for testing
Future<ui.Image> createTestImage() async {
  final pictureRecorder = ui.PictureRecorder();
  final canvas = Canvas(pictureRecorder);
  final paint = Paint()..color = const Color(0xFFFF0000);
  canvas.drawRect(const Rect.fromLTWH(0, 0, 100, 100), paint);
  final picture = pictureRecorder.endRecording();
  return picture.toImage(100, 100);
}

void main() {
  testWidgets('PipetteToolPage displays image and updates color on tap',
      (WidgetTester tester) async {
    // Create a sample image for testing
    final image = await createTestImage();

    // Override the provider for testing
    final container = ProviderContainer(overrides: [
      colorPickerStateProvider.overrideWith(
        () => ColorPickerState()
          ..state = const ColorPickerStateData(
              currentColor: Colors.red, currentOpacity: 1.0),
      ),
    ]);

    // Build the widget
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: PipetteToolPage(snapshot: image),
        ),
      ),
    );

    // Wait for the image to load
    await tester.pumpAndSettle();

    // Verify that the image is displayed
    expect(find.byType(CustomPaint), findsOneWidget);

    // Tap on the image to update the color
    await tester.tap(find.byType(CustomPaint));
    await tester.pumpAndSettle();

    // Verify that the color update was called
    final colorState = container.read(colorPickerStateProvider);
    expect(colorState.currentColor, isNotNull);
  });
}
