import 'package:flutter/material.dart';

part 'brush_painter.dart';

class DrawingBoard extends StatefulWidget {
  const DrawingBoard({Key? key}) : super(key: key);

  @override
  State<DrawingBoard> createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  final paths = <Path>[];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDarkTheme =
            MediaQuery.of(context).platformBrightness == Brightness.dark;
        return GestureDetector(
          onPanStart: (details) {
            final newPath = Path()
              ..moveTo(details.localPosition.dx, details.localPosition.dy);
            setState(() => paths.add(newPath));
          },
          onPanUpdate: (details) {
            setState(() => paths.last.lineTo(
                  details.localPosition.dx,
                  details.localPosition.dy,
                ));
          },
          onPanEnd: (_) {
              if (paths.last.getBounds().size == Size.zero) {
                setState(() => paths.last.close());
              }
          },
          child: CustomPaint(
            size: constraints.biggest,
            painter: BrushPainter(
              paths,
              isDarkTheme ? Colors.white70 : Colors.black87,
            ),
          ),
        );
      },
    );
  }
}
