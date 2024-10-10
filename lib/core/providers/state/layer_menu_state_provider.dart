import 'package:paintroid/core/providers/state/layer_menu_state_data.dart';
import 'package:paintroid/core/providers/state/layer_state_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'layer_menu_state_provider.g.dart';

@Riverpod(keepAlive: true)
class LayerMenuStateProvider extends _$LayerMenuStateProvider {
  @override
  LayerMenuStateData build() {
    return const LayerMenuStateData(
      isVisible: false,
      layer: [
        LayerStateData(id: 0, isSelected: false),
        LayerStateData(id: 1, isSelected: false),
        LayerStateData(id: 2, isSelected: false),
        LayerStateData(id: 3, isSelected: false),
        LayerStateData(id: 4, isSelected: false),
        LayerStateData(id: 5, isSelected: false),
        LayerStateData(id: 6, isSelected: false),
      ],
    );
  }

  void toggleVisibility() =>
      state = state.copyWith(isVisible: !state.isVisible);

  void hide() => state = state.copyWith(isVisible: false);

  void reorder(int oldIndex, int newIndex) {
    List<LayerStateData> layerList = List.from(state.layer);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final movedLayer = layerList.removeAt(oldIndex);
    layerList.insert(newIndex, movedLayer);
    state = state.copyWith(layer: layerList);
  }

  void toggleSelection(int layerId) {
    final updatedLayerList = state.layer.map((layer) {
      if (layer.id == layerId) {
        return layer.copyWith(isSelected: !layer.isSelected);
      }
      return layer;
    }).toList();
    state = state.copyWith(layer: updatedLayerList);
  }

  void addLayer() {
    final newLayer = LayerStateData(
      id: state.layer.length + 1,
      isSelected: false,
    );
    state = state.copyWith(layer: [...state.layer, newLayer]);
  }

  void deleteLayer() {
    final updatedLayerList =
        state.layer.where((layer) => !layer.isSelected).toList();
    state = state.copyWith(layer: updatedLayerList);
  }
}
