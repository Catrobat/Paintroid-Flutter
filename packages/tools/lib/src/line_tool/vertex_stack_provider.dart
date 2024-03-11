import 'dart:collection';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tools/tools.dart';

part 'vertex_stack_provider.g.dart';

@riverpod
Queue<Vertex> vertexStack(VertexStackRef ref) {
  return Queue();
}
