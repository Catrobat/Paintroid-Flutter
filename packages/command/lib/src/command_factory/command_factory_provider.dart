import 'package:command/command.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'command_factory_provider.g.dart';

@Riverpod(keepAlive: true)
CommandFactory commandFactory(CommandFactoryRef ref) {
  return const CommandFactory();
}
