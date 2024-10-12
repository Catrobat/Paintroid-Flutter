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
      layer: [
        LayerStateData(
          key: ValueKey(uuid.v4()),
          isSelected: false,
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
    List<LayerStateData> layerList = List.from(state.layer);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final movedLayer = layerList.removeAt(oldIndex);
    layerList.insert(newIndex, movedLayer);
    state = state.copyWith(layer: layerList);
  }

  void toggleSelection(Key? layerKey) {
    final layers = state.layer;

    final selectedCount = layers.where((layer) => layer.isSelected).length;
    final unselectedCount = layers.length - selectedCount;

    final updatedLayerList = layers.map((layer) {
      if (layer.key == layerKey) {
        if (!layer.isSelected) {
          if (unselectedCount <= 1) {
            return layer;
          } else {
            return layer.copyWith(isSelected: true);
          }
        } else {
          return layer.copyWith(isSelected: false);
        }
      }
      return layer;
    }).toList();

    state = state.copyWith(layer: updatedLayerList);
  }

  void toggleLayerVisibility(Key? layerKey) {
    final updatedLayerList = state.layer.map((layer) {
      if (layer.key == layerKey) {
        return layer.copyWith(isVisible: !layer.isVisible);
      }
      return layer;
    }).toList();
    state = state.copyWith(layer: updatedLayerList);
  }

  void updateLayerOpacity(Key? layerKey, double opacity) {
    final updatedLayerList = state.layer.map((layer) {
      if (layer.key == layerKey) {
        return layer.copyWith(opacity: opacity);
      }
      return layer;
    }).toList();
    state = state.copyWith(layer: updatedLayerList);
  }

  void addLayer() {
    final newLayer = LayerStateData(
      key: ValueKey(uuid.v4()),
      isSelected: false,
      isVisible: true,
      opacity: 1.0,
    );
    state = state.copyWith(layer: [...state.layer, newLayer]);
  }

  void deleteLayer() {
    final updatedLayerList =
        state.layer.where((layer) => !layer.isSelected).toList();
    state = state.copyWith(layer: updatedLayerList);
  }
}
