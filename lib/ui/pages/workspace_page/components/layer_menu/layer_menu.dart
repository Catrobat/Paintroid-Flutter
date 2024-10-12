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

    return Align(
      alignment: Alignment.centerRight,
      child: FadeInOutWidget(
        isVisible: isVisible,
        child: Container(
          width: 200,
          constraints: BoxConstraints(
            maxHeight: _calculateHeight(layers.length, context),
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              Flexible(
                child: ReorderableListView(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  onReorder: (int oldIndex, int newIndex) {
                    ref.read(layerMenuStateProvider.notifier).reorder(
                          oldIndex,
                          newIndex,
                        );
                  },
                  children: List.generate(layers.length, (index) {
                    return Layer(
                      key: layers[index].key,
                      isSelected: layers[index].isSelected,
                      isVisible: layers[index].isVisible,
                      opacity: layers[index].opacity,
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

  double _calculateHeight(int layerCount, BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double maxHeight = screenHeight * 0.66;
    return (layerCount * layerHeight + 64).clamp(0.0, maxHeight);
  }
}
