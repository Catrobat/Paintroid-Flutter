// Package imports:

// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';

part 'graphic_factory_provider.g.dart';

@Riverpod(keepAlive: true)
GraphicFactory graphicFactory(GraphicFactoryRef ref) {
  return const GraphicFactory();
}
