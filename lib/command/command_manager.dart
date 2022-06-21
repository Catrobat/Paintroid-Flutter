import 'command.dart';

abstract class CommandManager<C extends Command> {
  CommandManager({required this.commands});

  final List<C> commands;
}
