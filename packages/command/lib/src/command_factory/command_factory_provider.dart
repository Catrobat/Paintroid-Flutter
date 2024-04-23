// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:command/command.dart';

part 'command_factory_provider.g.dart';

@Riverpod(keepAlive: true)
CommandFactory commandFactory(CommandFactoryRef ref) {
  return const CommandFactory();
}
