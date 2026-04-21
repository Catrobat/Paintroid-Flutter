import 'package:paintroid/core/providers/state/toolbox_state_data.dart';
import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';

class FakeToolBoxStateProvider extends ToolBoxStateProvider {
  final ToolBoxStateData _state;

  FakeToolBoxStateProvider(this._state);

  @override
  ToolBoxStateData build() {
    return _state;
  }
}
