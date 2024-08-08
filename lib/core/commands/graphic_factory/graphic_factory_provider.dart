
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';

part 'graphic_factory_provider.g.dart';

@Riverpod(keepAlive: true)
class GraphicFactoryProvider extends _$GraphicFactoryProvider {
  @override
  GraphicFactory build() {
    return const GraphicFactory();
  }
}
