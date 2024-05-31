// Package imports:

// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:paintroid/core/commands/command_factory/command_factory.dart';

part 'command_factory_provider.g.dart';

@Riverpod(keepAlive: true)
CommandFactory commandFactory(CommandFactoryRef ref) {
  return const CommandFactory();
}
