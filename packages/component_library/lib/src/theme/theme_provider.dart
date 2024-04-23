// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:component_library/component_library.dart';

final themeModeNotifierProvider =
    StateNotifierProvider<ThemeModeStateNotifier, ThemeModeState>(
        (ref) => ThemeModeStateNotifier());
