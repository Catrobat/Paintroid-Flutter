import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_rotating_shape_provider.g.dart';

@riverpod
class IsRotatingShapeProvider extends _$IsRotatingShapeProvider {
  @override
  bool build() {
    return false;
  }

  void rotating() {
    state = true;
  }

  void notRotating() {
    state = false;
  }
}