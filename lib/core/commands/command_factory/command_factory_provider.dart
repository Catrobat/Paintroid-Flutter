import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'command_factory_provider.g.dart';

@Riverpod(keepAlive: true)
class CommandFactoryProvider extends _$CommandFactoryProvider {
  @override
  CommandFactory build() {
    return const CommandFactory();
  }
}
