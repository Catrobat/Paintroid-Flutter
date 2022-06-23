import 'package:flutter/material.dart';
import 'package:paintroid/command/graphic_command.dart';

class DrawCommandPainter extends CustomPainter {
  DrawCommandPainter({required Iterable<GraphicCommand> commands})
      : _graphicCommands = commands;

  final Iterable<GraphicCommand> _graphicCommands;

  @override
  void paint(Canvas canvas, Size size) {
    for (final command in _graphicCommands) {
      command.call(canvas);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
