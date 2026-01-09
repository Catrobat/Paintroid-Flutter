import 'dart:ui' as ui;
import 'package:colorpicker/src/colorpicker.dart';
import 'package:colorpicker/src/components/color_comparison.dart';
import 'package:colorpicker/src/components/pipette_tool_button.dart';
import 'package:colorpicker/src/pages/pipette_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Pipette button is displayed in ColorPicker',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ColorPicker(
              currentColor: Colors.blue,
              onColorChanged: _dummyOnColorChanged,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(PipetteToolButton), findsOneWidget);
    expect(find.text('PIPETTE'), findsOneWidget);
  });

  testWidgets('Pipette button is correctly aligned in the header',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ColorPicker(
              currentColor: Colors.blue,
              onColorChanged: _dummyOnColorChanged,
            ),
          ),
        ),
      ),
    );

    final rowFinder = find
        .descendant(
          of: find.byType(ColorPicker),
          matching: find.byType(Row),
        )
        .first;

    final Row row = tester.widget(rowFinder);

    expect(row.mainAxisAlignment, MainAxisAlignment.spaceBetween);
    expect(row.crossAxisAlignment, CrossAxisAlignment.start);
  });

  testWidgets(
      'Pipette button navigates to PipettePage when snapshot is provided',
      (WidgetTester tester) async {
    final mockImage = await _createDummyImage();

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ColorPicker(
              currentColor: Colors.blue,
              onColorChanged: _dummyOnColorChanged,
              snapshotImage: mockImage,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(PipetteToolButton));
    await tester.pumpAndSettle();

    expect(find.byType(PipettePage), findsOneWidget);
  });

  testWidgets('PipettePage displays the initial color correctly',
      (WidgetTester tester) async {
    final mockImage = await _createDummyImage();
    const initialColor = Colors.blue;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ColorPicker(
              currentColor: initialColor,
              onColorChanged: _dummyOnColorChanged,
              snapshotImage: mockImage,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    await tester.tap(find.byType(PipetteToolButton));
    await tester.pumpAndSettle();

    final colorPreviewFinder = find.descendant(
      of: find.byType(AppBar),
      matching: find.byWidgetPredicate((widget) =>
          widget is Container &&
          widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).color?.toARGB32() ==
              initialColor.toARGB32()),
    );

    expect(colorPreviewFinder, findsOneWidget);
  });

  testWidgets('Pipette button does nothing when snapshot is not provided',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ColorPicker(
              currentColor: Colors.blue,
              onColorChanged: _dummyOnColorChanged,
              snapshotImage: null,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(PipetteToolButton));
    await tester.pumpAndSettle();

    expect(find.byType(PipettePage), findsNothing);
  });

  testWidgets('Loupe appears when dragging in PipettePage',
      (WidgetTester tester) async {
    final mockImage = await _createDummyImage();

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ColorPicker(
              currentColor: Colors.blue,
              onColorChanged: _dummyOnColorChanged,
              snapshotImage: mockImage,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(PipetteToolButton));
    await tester.pumpAndSettle();

    final pipetteBodyGestureDetector = find.descendant(
      of: find.byType(PipettePage),
      matching: find.byWidgetPredicate(
        (widget) => widget is GestureDetector && widget.child is Stack,
      ),
    );

    expect(find.byType(ClipOval), findsNothing);

    final gesture =
        await tester.startGesture(tester.getCenter(pipetteBodyGestureDetector));
    await tester.pump();

    expect(find.byType(ClipOval), findsOneWidget);

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('Select color in PipettePage and see preview',
      (WidgetTester tester) async {
    final mockImage = await _createDummyImage(const Color(0xFF00FF00));

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ColorPicker(
              currentColor: Colors.blue,
              onColorChanged: (color) {},
              snapshotImage: mockImage,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    await tester.tap(find.byType(PipetteToolButton));
    await tester.pumpAndSettle();

    final pipetteBodyGestureDetector = find.descendant(
      of: find.byType(PipettePage),
      matching: find.byWidgetPredicate(
        (widget) => widget is GestureDetector && widget.child is Stack,
      ),
    );

    await tester.drag(pipetteBodyGestureDetector, const Offset(10, 10));
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      await Future.delayed(const Duration(milliseconds: 200));
    });

    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();

    final colorComparison =
        tester.widget<ColorComparison>(find.byType(ColorComparison));
    expect(colorComparison.newColor.toARGB32(),
        const Color(0xFF00FF00).toARGB32());
  });

  testWidgets('Save changes dialog appears and handles YES action',
      (WidgetTester tester) async {
    final mockImage = await _createDummyImage(const Color(0xFF00FF00));

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ColorPicker(
              currentColor: Colors.blue,
              onColorChanged: (color) {},
              snapshotImage: mockImage,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    await tester.tap(find.byType(PipetteToolButton));
    await tester.pumpAndSettle();

    final pipetteBodyGestureDetector = find.descendant(
      of: find.byType(PipettePage),
      matching: find.byWidgetPredicate(
        (widget) => widget is GestureDetector && widget.child is Stack,
      ),
    );

    await tester.drag(pipetteBodyGestureDetector, const Offset(10, 10));
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      await Future.delayed(const Duration(milliseconds: 200));
    });

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Save changes?'), findsOneWidget);

    await tester.tap(find.text('YES'));
    await tester.pumpAndSettle();

    expect(find.byType(PipettePage), findsNothing);
    final colorComparison =
        tester.widget<ColorComparison>(find.byType(ColorComparison));
    expect(colorComparison.newColor.toARGB32(),
        const Color(0xFF00FF00).toARGB32());
  });

  testWidgets('Save changes dialog appears and handles NO action',
      (WidgetTester tester) async {
    final mockImage = await _createDummyImage(const Color(0xFF00FF00));
    const initialColor = Colors.blue;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ColorPicker(
              currentColor: initialColor,
              onColorChanged: (color) {},
              snapshotImage: mockImage,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    final initialColorComparison =
        tester.widget<ColorComparison>(find.byType(ColorComparison));
    final colorBeforePipette = initialColorComparison.newColor;

    await tester.tap(find.byType(PipetteToolButton));
    await tester.pumpAndSettle();

    final pipetteBodyGestureDetector = find.descendant(
      of: find.byType(PipettePage),
      matching: find.byWidgetPredicate(
        (widget) => widget is GestureDetector && widget.child is Stack,
      ),
    );

    await tester.drag(pipetteBodyGestureDetector, const Offset(10, 10));
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      await Future.delayed(const Duration(milliseconds: 200));
    });

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Save changes?'), findsOneWidget);

    await tester.tap(find.text('NO'));
    await tester.pumpAndSettle();

    expect(find.byType(PipettePage), findsNothing);
    final finalColorComparison =
        tester.widget<ColorComparison>(find.byType(ColorComparison));
    expect(finalColorComparison.newColor.toARGB32(),
        colorBeforePipette.toARGB32());
  });
}

Future<ui.Image> _createDummyImage([Color color = Colors.red]) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawRect(const Rect.fromLTWH(0, 0, 10, 10), Paint()..color = color);
  final picture = recorder.endRecording();
  return await picture.toImage(10, 10);
}

void _dummyOnColorChanged(Color color) {}
