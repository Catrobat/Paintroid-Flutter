import 'package:flutter/material.dart';
import 'package:paintroid/command/command.dart';

class CommandPainter extends CustomPainter {
  CommandPainter(this.commandManager);

  final CommandManager commandManager;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    commandManager.executeLastCommand(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
