import 'package:flutter/cupertino.dart';
import 'package:paintroid/core/providers/state/layer_menu_state_data.dart';
import 'package:paintroid/core/providers/state/layer_state_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'layer_menu_state_provider.g.dart';

@Riverpod(keepAlive: true)
class LayerMenuStateProvider extends _$LayerMenuStateProvider {
  final uuid = const Uuid();

  @override
  LayerMenuStateData build() {
    return LayerMenuStateData(
      isVisible: false,
      layers: [
        LayerStateData(
          key: ValueKey(uuid.v4()),
          isSelected: true,
          isVisible: true,
          opacity: 1.0,
        ),
      ],
    );
  }

  void toggleMenuVisibility() =>
      state = state.copyWith(isVisible: !state.isVisible);

  void hide() => state = state.copyWith(isVisible: false);

  void reorder(int oldIndex, int newIndex) {
    List<LayerStateData> layerList = List.from(state.layers);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final movedLayer = layerList.removeAt(oldIndex);
    layerList.insert(newIndex, movedLayer);
    state = state.copyWith(layers: layerList);
  }

  void toggleSelection(Key? layerKey) {
    final updatedLayerList = state.layers.map((layer) {
      if (layer.key == layerKey) {
        return layer.copyWith(isSelected: true);
      }
      return layer.copyWith(isSelected: false);
    }).toList();

    state = state.copyWith(layers: updatedLayerList);
  }

  void toggleLayerVisibility(Key? layerKey) {
    final updatedLayerList = state.layers.map((layer) {
      if (layer.key == layerKey) {
        return layer.copyWith(isVisible: !layer.isVisible);
      }
      return layer;
    }).toList();
    state = state.copyWith(layers: updatedLayerList);
  }

  void updateLayerOpacity(Key? layerKey, double opacity) {
    final updatedLayerList = state.layers.map((layer) {
      if (layer.key == layerKey) {
        return layer.copyWith(opacity: opacity);
      }
      return layer;
    }).toList();
    state = state.copyWith(layers: updatedLayerList);
  }

  void addLayer() {
    // deselect all layers
    final updatedLayerList = state.layers.map((layer) {
      return layer.copyWith(isSelected: false);
    }).toList();
    final newLayer = LayerStateData(
      key: ValueKey(uuid.v4()),
      isSelected: true,
      isVisible: true,
      opacity: 1.0,
    );
    updatedLayerList.add(newLayer);
    state = state.copyWith(layers: updatedLayerList);
  }

  void deleteLayer() {
    if (state.layers.length == 1) return;
    final updatedLayerList =
        state.layers.where((layer) => !layer.isSelected).toList();
    final lastIndex = updatedLayerList.length - 1;
    updatedLayerList[lastIndex] =
        updatedLayerList[lastIndex].copyWith(isSelected: true);

    state = state.copyWith(layers: updatedLayerList);
  }
}
