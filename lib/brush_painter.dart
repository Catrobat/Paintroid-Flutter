part of 'drawing_board.dart';

class BrushPainter extends CustomPainter {
  final List<Path> paths;
  final Color color;

  BrushPainter(this.paths, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;
    for (final path in paths) {
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
