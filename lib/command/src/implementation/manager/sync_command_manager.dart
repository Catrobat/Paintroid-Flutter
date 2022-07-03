import 'package:paintroid/command/command.dart';

class SyncCommandManager<C extends Command> extends CommandManager<C> {
  SyncCommandManager({required List<C> commands}) : super(commands: commands);
}
