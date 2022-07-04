import 'package:flutter_riverpod/flutter_riverpod.dart';

class StateProviders {
  StateProviders._();

  static final isFullscreen = StateProvider((ref) => false);
  static final isUserDrawing = StateProvider((ref) => false);
}
