import 'package:paintroid/command/command.dart';
import 'package:paintroid/command/command_manager.dart';

class SyncCommandManager<C extends Command> extends CommandManager<C> {
  SyncCommandManager({required List<C> commands}) : super(commands: commands);
}
