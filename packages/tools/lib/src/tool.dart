import 'dart:ui';

import 'package:command/command.dart';

abstract class Tool {
  const Tool({
    required this.paint,
    required this.commandManager,
    required this.commandFactory,
  });

  final Paint paint;
  final CommandManager commandManager;
  final CommandFactory commandFactory;

  void onDown(Offset point);

  void onDrag(Offset point);

  void onUp(Offset? point);

  void onCancel();
}
