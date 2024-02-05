import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckMarkClickedState extends ChangeNotifier {
  static final provider = ChangeNotifierProvider(
    (ref) => CheckMarkClickedState(),
  );

  void notify() => notifyListeners();
}
