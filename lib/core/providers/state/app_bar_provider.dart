// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_bar_provider.g.dart';

@riverpod
class AppBarProvider extends _$AppBarProvider {
  @override
  AppBarProvider build() => this;

  void update() => ref.notifyListeners();
}
