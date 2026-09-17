import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdvancedSettingsPanelVisibilityProvider extends Notifier<bool> {
  @override
  bool build() => false;

  void show() => state = true;

  void hide() => state = false;
}

final advancedSettingsPanelVisibilityProvider =
    NotifierProvider<AdvancedSettingsPanelVisibilityProvider, bool>(
  () => AdvancedSettingsPanelVisibilityProvider(),
);
