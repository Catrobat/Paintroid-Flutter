import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/command/command.dart';

class SyncCommandManager<C extends Command> extends CommandManager<C> {
  SyncCommandManager({required List<C> commands}) : super(commands: commands);

  static final provider =
      Provider((ref) => SyncCommandManager<GraphicCommand>(commands: []));
}
