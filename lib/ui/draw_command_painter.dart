import 'package:flutter/material.dart';
import 'package:paintroid/command/draw_command.dart';

class DrawCommandPainter extends CustomPainter {
  DrawCommandPainter({required Iterable<DrawCommand> commands})
      : _drawCommands = commands;

  final Iterable<DrawCommand> _drawCommands;

  @override
  void paint(Canvas canvas, Size size) {
    for (final command in _drawCommands) {
      command.call(canvas);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
