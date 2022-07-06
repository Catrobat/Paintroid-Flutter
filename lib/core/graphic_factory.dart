import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/path_with_action_history.dart';

class GraphicFactory {
  const GraphicFactory();

  static final provider = Provider((ref) => const GraphicFactory());

  Paint createPaint() => Paint();

  PathWithActionHistory createPathWithActionHistory() =>
      PathWithActionHistory();
}
