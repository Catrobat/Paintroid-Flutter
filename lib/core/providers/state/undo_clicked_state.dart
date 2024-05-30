// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UndoClickedState extends ChangeNotifier {
  static final provider = ChangeNotifierProvider(
    (ref) => UndoClickedState(),
  );

  void notify() => notifyListeners();
}
