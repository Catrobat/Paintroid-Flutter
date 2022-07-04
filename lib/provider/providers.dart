import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/command/command.dart';
import 'package:paintroid/core/graphic_factory.dart';

class Providers {
  Providers._();

  static final graphicCommandManager = Provider(
    (ref) => SyncCommandManager<GraphicCommand>(commands: []),
  );
  static final commandFactory = Provider((ref) => const CommandFactory());
  static final graphicFactory = Provider((ref) => const GraphicFactory());
}
