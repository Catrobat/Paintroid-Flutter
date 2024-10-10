import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/providers/state/layer_menu_state_provider.dart';
import 'package:paintroid/ui/pages/workspace_page/components/layer_menu/layer.dart';
import 'package:paintroid/ui/shared/fade_in_out_widget.dart';

class LayerMenu extends ConsumerWidget {
  const LayerMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = ref.watch(
      layerMenuStateProvider.select((state) => state.isVisible),
    );
    final layers = ref.watch(
      layerMenuStateProvider.select((state) => state.layer),
    );
    return Positioned(
      top: 54,
      bottom: 54,
      right: 8,
      child: FadeInOutWidget(
        isVisible: isVisible,
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      ref.read(layerMenuStateProvider.notifier).addLayer();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      ref.read(layerMenuStateProvider.notifier).deleteLayer();
                    },
                  ),
                ],
              ),
              Expanded(
                child: ReorderableListView(
                  padding: const EdgeInsets.all(8),
                  onReorder: (int oldIndex, int newIndex) {
                    ref.read(layerMenuStateProvider.notifier).reorder(
                          oldIndex,
                          newIndex,
                        );
                  },
                  children: List.generate(layers.length, (index) {
                    return Layer(
                      id: layers[index].id,
                      key: ValueKey(layers[index].id),
                      isSelected: layers[index].isSelected,
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
