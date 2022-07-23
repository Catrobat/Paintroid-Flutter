import 'dart:ui';

import '../../command.dart';
import '../../command_manager.dart';
import '../../graphic_command.dart';

class SyncCommandManager implements CommandManager {
  SyncCommandManager({required List<Command> commands}) : _history = commands;

  final List<Command> _history;

  @override
  Iterable<Command> get history => List.unmodifiable(_history);

  @override
  int get count => _history.length;

  @override
  void addGraphicCommand(GraphicCommand command) {
    _history.add(command);
  }

  @override
  void executeLastCommand(Canvas canvas) {
    if (_history.isEmpty) return;
    final lastCommand = _history.last;
    if (lastCommand is GraphicCommand) {
      lastCommand.call(canvas);
    }
  }

  @override
  void executeAllCommands(Canvas canvas) {
    for (final command in _history) {
      if (command is GraphicCommand) {
        command.call(canvas);
      }
    }
  }

  @override
  void resetHistory({Iterable<Command>? newCommands}) {
    _history.clear();
    if (newCommands != null) {
      _history.addAll(newCommands);
    }
  }
}
