// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopBarActionClickedState extends ChangeNotifier {
  static final provider = ChangeNotifierProvider(
    (ref) => TopBarActionClickedState(),
  );

  void notify() => notifyListeners();
}
