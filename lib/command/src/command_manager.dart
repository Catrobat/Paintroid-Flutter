import 'command.dart';

abstract class CommandManager<C extends Command> {
  const CommandManager({required this.commands});

  final List<C> commands;
}
