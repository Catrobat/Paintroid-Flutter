import 'dart:ui';

import 'package:paintroid/command/command.dart';
import 'package:paintroid/command/command_factory.dart';
import 'package:paintroid/command/command_manager.dart';

abstract class Tool<C extends Command> {
  const Tool({
    required this.paint,
    required this.commandManager,
    required this.commandFactory,
  });

  final Paint paint;
  final CommandManager<C> commandManager;
  final CommandFactory commandFactory;

  void onDown(Offset point);

  void onDrag(Offset point);

  void onUp(Offset? point);
}
