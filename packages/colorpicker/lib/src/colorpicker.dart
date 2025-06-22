import 'package:colorpicker/src/constants/color_picker_constants.dart';
import 'package:colorpicker/src/components/checkerboard_square.dart';
import 'package:colorpicker/src/components/color_comparison.dart';
import 'package:colorpicker/src/components/hsv_slider_group.dart';
import 'package:colorpicker/src/components/color_wheel.dart';
import 'package:colorpicker/src/components/opacity_slider.dart';
import 'package:colorpicker/src/components/hue_saturation_picker.dart';
import 'package:colorpicker/src/components/rgb_slider_group.dart';
import 'package:colorpicker/src/constants/color_picker_enums.dart';
import 'package:colorpicker/src/constants/colors.dart';
import 'package:colorpicker/src/state/color_picker_state_provider.dart';
import 'package:colorpicker/src/state/recent_color_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/ui/theme/theme.dart';

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
  AdvancedPickerMode _advancedPickerMode = AdvancedPickerMode.picker;
  SliderTypeMode _sliderTypeMode = SliderTypeMode.hsv;

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
          .updateColor(widget.currentColor);
      ref
          .read(colorPickerStateProvider.notifier)
          .updateOpacity(widget.currentColor.a / 255.0);
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

/*
  void _handleColorChange(Color color) {
    ref
        .read(colorPickerStateProvider.notifier)
        .updateColor(color.withAlpha((255).toInt()));
    ref.read(colorPickerStateProvider.notifier).updateOpacity(color.a);
  }
*/

  void _handleColorChange(Color color) {
    final opacity = ref
        .read(colorPickerStateProvider)
        .currentOpacity;
    final updatedColor = color.withAlpha((opacity * 255).toInt());

    ref.read(colorPickerStateProvider.notifier).updateColor(updatedColor);
    ref
        .read(colorPickerStateProvider.notifier)
        .updateOpacity(color.a);
  }


  Widget _buildRecentColorsSection() {
    final recentColors = ref.watch(recentColorsProvider);
    final theme = Theme.of(context);

    if (recentColors.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: recentColors.map((color) {
            return GestureDetector(
              onTap: () {
                _handleColorChange(color);
              },
              child: Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(color: theme.dividerColor, width: 1.0),
                ),
                child: color.a < 1.0 ? const CheckerboardSquare() : null,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8.0),
        Text(
          'recently used',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodySmall?.color
                ?.withAlpha((178.5).toInt()),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // final colorPickerState = ref.watch(colorPickerStateProvider);
    // final displayColor = colorPickerState.currentColor
    //         ?.withAlpha((colorPickerState.currentOpacity * 255).toInt()) ??
    //     widget.currentColor;
    // final solidColorForPickers =
    //     (colorPickerState.currentColor ?? widget.currentColor)
    //         .withAlpha((255).toInt());

    final colorPickerState = ref.watch(colorPickerStateProvider);
    final opacity = colorPickerState.currentOpacity;

    final displayColor = (colorPickerState.currentColor ?? widget.currentColor)
        .withAlpha((opacity * 255).toInt());

    final solidColorForPickers =
    (colorPickerState.currentColor ?? widget.currentColor)
        .withAlpha((opacity * 255).toInt());


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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ColorComparison(
                currentColor: widget.currentColor,
                newColor: displayColor,
              ),
              _buildRecentColorsSection(),
              const SizedBox(height: 20.0),
              SizedBox(
                height: 48,
                child: TabBar(
                  controller: _tabController,
                  labelColor: colorScheme.primary,
                  dividerHeight: 0,
                  unselectedLabelColor:
                  colorScheme.onSurface.withAlpha((255 * 0.7).toInt()),
                  indicator: const BoxDecoration(),
                  tabs: <Widget>[
                    _buildCustomTab(
                        const Icon(
                          Icons.grid_on,
                        ),
                        0),
                    _buildCustomTab(const Icon(Icons.circle), 1),
                    _buildCustomTab(const Icon(Icons.tune), 2),
                  ],
                ),
              ),
              const SizedBox(height: 15.0),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _buildPickerContent(solidColorForPickers),
              ),
              if (_mainPickerMode != MainPickerMode.sliders) ...[
                const SizedBox(height: 20.0),
                OpacitySlider(gradientColor: solidColorForPickers),
              ],
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('CANCEL',
                        style: TextStyle(
                            color: CustomColors.oceanBlue,
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
                            color: CustomColors.oceanBlue,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPickerContent(Color colorForPickers) {
    final theme = Theme.of(context);
    final paintroidTheme = PaintroidTheme.of(context);
    final colorScheme = theme.colorScheme;

    switch (_mainPickerMode) {
      case MainPickerMode.grid:
        return _buildGridPicker();
      case MainPickerMode.advanced:
        return _buildAdvancedPicker(colorForPickers, 'Picker', 'Wheel');
      case MainPickerMode.sliders:
        return Column(
          key: const ValueKey('slider_picker'),
          mainAxisSize: MainAxisSize.min,
          children: [
            ToggleButtons(
              isSelected: [
                _sliderTypeMode == SliderTypeMode.hsv,
                _sliderTypeMode == SliderTypeMode.rgb,
              ],
              onPressed: (int index) {
                setState(() {
                  _sliderTypeMode =
                  index == 0 ? SliderTypeMode.hsv : SliderTypeMode.rgb;
                });
              },
              borderRadius: BorderRadius.circular(18.0),
              borderWidth: 1.5,
              borderColor: colorScheme.primary,
              selectedBorderColor: colorScheme.primary,
              fillColor: paintroidTheme.surfaceColor,
              color: paintroidTheme.orangeColor,
              constraints:
              const BoxConstraints(minHeight: 30.0, minWidth: 70.0),
              children: <Widget>[
                _buildToggleItem(
                    context, 'HSV', _sliderTypeMode, SliderTypeMode.hsv),
                _buildToggleItem(
                    context, 'RGB', _sliderTypeMode, SliderTypeMode.rgb),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: _sliderTypeMode == SliderTypeMode.hsv
                  ? HsvSliderGroup(
                  initialColor: colorForPickers,
                  onColorChanged: _handleColorChange)
                  : RgbSliderGroup(
                  initialColor: colorForPickers,
                  onColorChanged: _handleColorChange),
            ),
          ],
        );
    }
  }

  Widget _buildGridPicker() {
    const List<Color> colors = DisplayColors.colors;
    final theme = Theme.of(context);

    return GridView.builder(
      key: const ValueKey('grid_picker'),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: colors.length + 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 6.0,
        mainAxisSpacing: 6.0,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        if (index == colors.length) {
          return GestureDetector(
            onTap: () => _handleColorChange(Colors.transparent),
            child: const CheckerboardSquare(),
          );
        }
        final color = colors[index];
        return GestureDetector(
          onTap: () => _handleColorChange(color),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: theme.dividerColor, width: 1.0),
            ),
          ),
        );
      },
    );
  }

  Widget _buildToggleItem<T>(BuildContext context,
      String text,
      T currentMode,
      T buttonMode,) {
    final bool isSelected = currentMode == buttonMode;
    final colorScheme = Theme
        .of(context)
        .colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (isSelected)
            Icon(
              Icons.check,
              size: 18.0,
              color: colorScheme.onSurface,
            ),
          if (isSelected) const SizedBox(width: 6.0),
          Text(
            text,
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedPicker(Color colorForPickers, String text1,
      String text2) {
    final theme = Theme.of(context);
    final paintroidTheme = PaintroidTheme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      key: const ValueKey('advanced_picker'),
      mainAxisSize: MainAxisSize.min,
      children: [
        ToggleButtons(
          isSelected: [
            _advancedPickerMode == AdvancedPickerMode.picker,
            _advancedPickerMode == AdvancedPickerMode.wheel,
          ],
          onPressed: (int index) {
            setState(() {
              _advancedPickerMode = index == 0
                  ? AdvancedPickerMode.picker
                  : AdvancedPickerMode.wheel;
            });
          },
          borderRadius: BorderRadius.circular(18.0),
          borderWidth: 1.5,
          borderColor: colorScheme.primary,
          selectedBorderColor: colorScheme.primary,
          fillColor: paintroidTheme.surfaceColor,
          constraints: const BoxConstraints(minHeight: 30.0, minWidth: 70.0),
          children: <Widget>[
            _buildToggleItem(
                context, text1, _advancedPickerMode, AdvancedPickerMode.picker),
            _buildToggleItem(
                context, text2, _advancedPickerMode, AdvancedPickerMode.wheel),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 220.0,
          child: Center(
            child: _advancedPickerMode == AdvancedPickerMode.picker
                ? HueSaturationValuePicker(
                initialColor: colorForPickers,
                onColorChanged: _handleColorChange)
                : ColorWheel(
                pickerColor: colorForPickers,
                onColorChanged: _handleColorChange),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomTab(Icon iconWidget, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
        animation: _tabController,
        builder: (BuildContext context, Widget? child) {
          final bool isSelected = _tabController.index == index;
          return GestureDetector(
            onTap: () {
              if (_tabController.index != index) {
                _tabController.animateTo(index);
              }
            },
            child: Container(
              height: 48,
              padding: const EdgeInsets.only(bottom: 2.0),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Center(
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return hueSweepGradient.createShader(bounds);
                          },
                          blendMode: BlendMode.srcIn,
                          child: IconTheme(
                            data: const IconThemeData(
                              color: Colors.white,
                            ),
                            child: iconWidget,
                          ),
                        )),
                  ),
                  Container(
                    height: isSelected
                        ? _selectedIndicatorHeight
                        : _unselectedIndicatorHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:
                      isSelected ? colorScheme.primary : theme.dividerColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
