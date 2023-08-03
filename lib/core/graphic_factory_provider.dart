import 'package:paintroid/core/graphic_factory.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'graphic_factory_provider.g.dart';

@Riverpod(keepAlive: true)
GraphicFactory graphicFactory(GraphicFactoryRef ref) {
  return const GraphicFactory();
}
