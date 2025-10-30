import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/providers/state/layers_panel_visibility_state_provider.dart';

class LayerData {
  final String id;
  final double opacity;
  final bool isVisible;

  LayerData({
    required this.id,
    this.opacity = 100.0,
    this.isVisible = true,
  });

  LayerData copyWith({
    String? id,
    double? opacity,
    bool? isVisible,
  }) {
    return LayerData(
      id: id ?? this.id,
      opacity: opacity ?? this.opacity,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

class LayersPanel extends ConsumerStatefulWidget {
  const LayersPanel({super.key});

  static const double panelWidth = 260.0;

  @override
  ConsumerState<LayersPanel> createState() => _LayersPanelState();
}

class _LayersPanelState extends ConsumerState<LayersPanel> {
  List<LayerData> layers = [
    LayerData(id: 'Layer 1', opacity: 100),
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isVisible = ref.watch(layersPanelVisibilityStateProvider);
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final topPadding = mediaQuery.padding.top;
    final bottomPadding = mediaQuery.padding.bottom;

    const appBarHeight = 56.0;
    const bottomNavBarHeight = 64.0;
    const verticalSpacing = 16.0;

    final maxPanelHeight = screenHeight -
        appBarHeight -
        bottomNavBarHeight -
        topPadding -
        bottomPadding -
        (verticalSpacing * 2);

    return Align(
      alignment: Alignment.centerRight,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.translationValues(
          isVisible ? 0 : LayersPanel.panelWidth,
          0,
          0,
        ),
        child: Material(
          elevation: 8,
          child: Container(
            width: LayersPanel.panelWidth,
            constraints: BoxConstraints(
              maxHeight: maxPanelHeight,
            ),
            color: const Color(0xFF4A7C8C),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                Flexible(
                  child: SingleChildScrollView(
                    child: _buildLayersList(),
                  ),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.visibility, color: Colors.white70),
            onPressed: () {},
            tooltip: 'Toggle all layers visibility',
          ),
          IconButton(
            icon: const Icon(Icons.water_drop, color: Colors.white70),
            onPressed: () {},
            tooltip: 'Opacity',
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _addNewLayer,
            tooltip: 'Add new layer',
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white70),
            onPressed: _deleteSelectedLayer,
            tooltip: 'Delete layer',
          ),
        ],
      ),
    );
  }

  Widget _buildLayersList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final item = layers.removeAt(oldIndex);
                layers.insert(newIndex, item);

                // Update selected index
                if (selectedIndex == oldIndex) {
                  selectedIndex = newIndex;
                } else if (oldIndex < selectedIndex &&
                    newIndex >= selectedIndex) {
                  selectedIndex -= 1;
                } else if (oldIndex > selectedIndex &&
                    newIndex <= selectedIndex) {
                  selectedIndex += 1;
                }
              });
            },
            children: [
              for (int index = 0; index < layers.length; index++)
                Container(
                  key: ValueKey(layers[index].id),
                  child: _buildLayerItem(index),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLayerItem(int index) {
    final layer = layers[index];
    final isSelected = index == selectedIndex;

    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF3D6B7A),
          border: isSelected
              ? Border.all(color: Colors.white.withOpacity(0.3), width: 1)
              : null,
        ),
        child: Row(
          children: [
            // Visibility checkbox
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: layer.isVisible,
                onChanged: (value) {
                  setState(() {
                    layers[index] = layer.copyWith(isVisible: value ?? true);
                  });
                },
                activeColor: Colors.white,
                checkColor: const Color(0xFF3D6B7A),
                side: const BorderSide(color: Colors.white70, width: 1.5),
              ),
            ),
            const SizedBox(width: 12),
            // Drag handle lines icon (custom three horizontal lines)
            ReorderableDragStartListener(
              index: index,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 20,
                    height: 2,
                    color: Colors.white54,
                  ),
                  const SizedBox(height: 3),
                  Container(
                    width: 20,
                    height: 2,
                    color: Colors.white54,
                  ),
                  const SizedBox(height: 3),
                  Container(
                    width: 20,
                    height: 2,
                    color: Colors.white54,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Vertical opacity slider with label
            SizedBox(
              height: 110,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 3,
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.white30,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 8,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 14,
                          ),
                          thumbColor: Colors.white,
                        ),
                        child: Slider(
                          value: layer.opacity,
                          min: 0,
                          max: 100,
                          onChanged: (value) {
                            setState(() {
                              layers[index] = layer.copyWith(opacity: value);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${layer.opacity.round()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Layer thumbnail
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white30, width: 1),
              ),
              child: CustomPaint(
                painter: CheckerboardPainter(),
                child: const Center(
                  child: Icon(
                    Icons.image_outlined,
                    color: Colors.grey,
                    size: 36,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return const SizedBox.shrink();
  }

  void _addNewLayer() {
    setState(() {
      layers.add(LayerData(
        id: 'Layer ${layers.length + 1}',
        opacity: 100,
      ));
    });
  }

  void _deleteSelectedLayer() {
    if (layers.length > 1 &&
        selectedIndex >= 0 &&
        selectedIndex < layers.length) {
      setState(() {
        layers.removeAt(selectedIndex);
        if (selectedIndex >= layers.length) {
          selectedIndex = layers.length - 1;
        }
      });
    }
  }
}

// Custom painter for checkerboard pattern (transparency indicator)
class CheckerboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const squareSize = 8.0;
    final paint = Paint()..color = Colors.grey.shade300;

    for (double i = 0; i < size.width; i += squareSize) {
      for (double j = 0; j < size.height; j += squareSize) {
        if ((i ~/ squareSize + j ~/ squareSize) % 2 == 0) {
          canvas.drawRect(
            Rect.fromLTWH(i, j, squareSize, squareSize),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
