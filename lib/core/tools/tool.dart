// Dart imports:
import 'dart:ui';

// Project imports:
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';

// Package imports:

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
