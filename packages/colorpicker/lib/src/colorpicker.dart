import 'package:flutter/material.dart';

import 'package:colorpicker/src/components/color_comparison.dart';
import 'package:colorpicker/src/components/opacity_slider.dart';
import 'package:colorpicker/src/components/recent_colors_section_widget.dart';
import 'package:colorpicker/src/components/custom_tab_widget.dart';
import 'package:colorpicker/src/components/picker_content_widget.dart';
import 'package:colorpicker/src/enums/main_picker_mode_type.dart';
import 'package:colorpicker/src/state/color_picker_state_provider.dart';
import 'package:colorpicker/src/state/recent_color_state_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:colorpicker/src/constants/colorpicker_colors.dart';

class ColorPicker extends ConsumerStatefulWidget {
  const ColorPicker({
    super.key,
    required this.currentColor,
    required this.onColorChanged,
  });

  final Color currentColor;
  final void Function(Color) onColorChanged;

  @override
  ConsumerState<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends ConsumerState<ColorPicker>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  MainPickerMode _mainPickerMode = MainPickerMode.grid;

  final double _selectedIndicatorHeight = 5.0;
  final double _unselectedIndicatorHeight = 2.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3,
        vsync: this,
        initialIndex: MainPickerMode.values.indexOf(_mainPickerMode));
    _tabController.addListener(_handleTabChange);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(colorPickerStateProvider.notifier)
          .updateColor(widget.currentColor.withAlpha(255));
      ref
          .read(colorPickerStateProvider.notifier)
          .updateOpacity(widget.currentColor.a);
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (mounted &&
        _mainPickerMode != MainPickerMode.values[_tabController.index]) {
      setState(() {
        _mainPickerMode = MainPickerMode.values[_tabController.index];
      });
    }
  }

  void _handleColorChange(Color color) {
    ref
        .read(colorPickerStateProvider.notifier)
        .updateColor(color.withAlpha(255));
  }

  void _handleColorAndOpacityChange(Color color) {
    ref
        .read(colorPickerStateProvider.notifier)
        .updateColor(color.withAlpha(255));
    ref.read(colorPickerStateProvider.notifier).updateOpacity(color.a);
  }

  @override
  Widget build(BuildContext context) {
    final colorPickerState = ref.watch(colorPickerStateProvider);
    final opacity = colorPickerState.currentOpacity;
    final baseColor = colorPickerState.currentColor ?? widget.currentColor;
    final displayColor =
        baseColor.withAlpha((opacity.clamp(0.0, 1.0) * 255).round());

    final solidColorForPickers =
        (colorPickerState.currentColor ?? widget.currentColor.withAlpha(255))
            .withAlpha(255);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ColorComparison(
                      currentColor: widget.currentColor,
                      newColor: displayColor,
                    ),
                    RecentColorsSectionWidget(
                        onColorSelected: _handleColorAndOpacityChange),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      height: 48,
                      child: TabBar(
                        controller: _tabController,
                        labelColor: colorScheme.primary,
                        dividerHeight: 0,
                        unselectedLabelColor: colorScheme.onSurface
                            .withAlpha((255 * 0.7).toInt()),
                        indicator: const BoxDecoration(),
                        tabs: <Widget>[
                          CustomTabWidget(
                            iconWidget: const Icon(Icons.grid_on),
                            index: 0,
                            tabController: _tabController,
                            selectedIndicatorHeight: _selectedIndicatorHeight,
                            unselectedIndicatorHeight:
                                _unselectedIndicatorHeight,
                          ),
                          CustomTabWidget(
                            iconWidget: const Icon(Icons.circle),
                            index: 1,
                            tabController: _tabController,
                            selectedIndicatorHeight: _selectedIndicatorHeight,
                            unselectedIndicatorHeight:
                                _unselectedIndicatorHeight,
                          ),
                          CustomTabWidget(
                            iconWidget: const Icon(Icons.tune),
                            index: 2,
                            tabController: _tabController,
                            selectedIndicatorHeight: _selectedIndicatorHeight,
                            unselectedIndicatorHeight:
                                _unselectedIndicatorHeight,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: PickerContentWidget(
                        mainPickerMode: _mainPickerMode,
                        colorForPickers: solidColorForPickers,
                        onColorChanged: _handleColorChange,
                        onColorAndOpacityChanged: _handleColorAndOpacityChange,
                      ),
                    ),
                    if (_mainPickerMode != MainPickerMode.sliders) ...[
                      const SizedBox(height: 20.0),
                      OpacitySlider(gradientColor: solidColorForPickers),
                    ],
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CANCEL',
                      style: TextStyle(
                          color: ColorPickerColors.oceanBlue,
                          fontWeight: FontWeight.w500)),
                ),
                const SizedBox(width: 15.0),
                TextButton(
                  onPressed: () {
                    ref
                        .read(recentColorsProvider.notifier)
                        .addColor(displayColor);
                    widget.onColorChanged(displayColor);
                    Navigator.pop(context);
                  },
                  child: const Text('APPLY',
                      style: TextStyle(
                          color: ColorPickerColors.oceanBlue,
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
