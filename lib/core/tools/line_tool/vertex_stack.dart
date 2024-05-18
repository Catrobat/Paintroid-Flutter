// Dart imports:
import 'dart:collection';

// Project imports:
import 'package:paintroid/core/tools/line_tool/line_tool_vertex.dart';

class VertexStack extends Iterable<Vertex> {
  final _stack = Queue<Vertex>();

  @override
  Iterator<Vertex> get iterator => _stack.iterator;

  @override
  bool get isEmpty => _stack.isEmpty;

  @override
  Vertex get last => _stack.last;

  void add(Vertex vertex) {
    _stack.add(vertex);
  }

  void clear() {
    _stack.clear();
  }

  Vertex? getPredecessor(Vertex vertex) {
    if (_stack.isEmpty) return null;
    if (_stack.length == 1) return null;
    if (_stack.first == vertex) return null;
    return _stack.elementAt(_stack.toList().indexOf(vertex) - 1);
  }

  Vertex? getSuccessor(Vertex vertex) {
    if (_stack.isEmpty) return null;
    if (_stack.length == 1) return null;
    if (_stack.last == vertex) return null;
    return _stack.elementAt(_stack.toList().indexOf(vertex) + 1);
  }
}
