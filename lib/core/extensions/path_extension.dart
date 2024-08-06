import 'dart:ui';

extension PathExtension on Path {
  void moveToOffset(Offset offset) => moveTo(offset.dx, offset.dy);
  void lineToOffset(Offset offset) => lineTo(offset.dx, offset.dy);
}
