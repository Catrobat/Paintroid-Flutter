// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CanvasDirtyNotifier extends ChangeNotifier {
  static final provider = ChangeNotifierProvider(
    (ref) => CanvasDirtyNotifier(),
  );

  void repaint() => notifyListeners();
}
