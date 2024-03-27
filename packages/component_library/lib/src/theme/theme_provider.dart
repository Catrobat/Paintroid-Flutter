import 'package:component_library/component_library.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeNotifierProvider =
    StateNotifierProvider<ThemeModeStateNotifier, ThemeModeState>(
        (ref) => ThemeModeStateNotifier());
