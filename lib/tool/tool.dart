import 'dart:ui';

import 'package:paintroid/command/command_manager.dart';

abstract class Tool {
  const Tool(this.paint, this.commandManager);

  final Paint paint;
  final CommandManager commandManager;

  void onDown(Offset point);

  void onDrag(Offset point);

  void onUp(Offset? point);
}
