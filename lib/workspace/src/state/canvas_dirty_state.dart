import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CanvasDirtyState extends ChangeNotifier {
  static final provider = ChangeNotifierProvider(
    (ref) => CanvasDirtyState(),
  );

  void repaint() => notifyListeners();
}
