import 'package:flutter/material.dart';
import 'package:paintroid/ui/shared/images/animated_light_bulb.dart';
import 'package:paintroid/ui/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> showTipDialog(BuildContext context) => showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Tip of the Day',
      pageBuilder: (_, __, ___) => const TipOfTheDayDialog(),
    );

Future<void> showTipIfEnabled(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final showTip = prefs.getBool('showTip') ?? true;
  if (showTip && context.mounted) {
    await showTipDialog(context);
  }
}

final List<Map<String, String>> tips = [
  {
    'title': 'Layer menu',
    'content':
        'Shows the current layers, you can add new, delete, show and hide layers and set transparency of the layer.',
  },
  {
    'title': 'Antialiasing',
    'content':
        'Antialiasing is the reduction of unwanted effects that can arise from the limited pixel grid. You can turn antialiasing on and off in the Advanced Settings.',
  },
  {
    'title': 'Smoothing',
    'content':
        'The idea is that the smaller details in the image are smoothed out. You can turn smoothing on and off in the Advanced Settings.',
  },
  {
    'title': 'Zoom window settings',
    'content': 'The zoom window can be turned on or off and the zoom can be changed here.',
  },
  {
    'title': 'Export',
    'content':
        'The created image can be saved in various image formats (png, jpg, ...). It is also possible to save it as a catrobat-image in order to continue editing later.',
  },
  {
    'title': 'Load image',
    'content':
        'Upload an image or a catrobat-image. The uploaded image can replace the current one or be added to the current layer.',
  },
  {
    'title': 'Color Picker',
    'content':
        'The color picker can be used to set the color and transparency for the tool. Use a predefined standard color or define a color yourself with RGB values and HEX codes. With the pipette you can choose an already existing color on the canvas.',
  },
  {
    'title': 'Hide Buttons',
    'content':
        'You can hide the header and the toolbar. You can display them again using the back button on your phone.',
  },
  {
    'title': 'Share image',
    'content': 'You can share your picture via messaging apps or email.',
  },
  {
    'title': 'Help',
    'content':
        'You can use \'Help\' in the menu to start the Paintroid tutorial, where the tools and functions are explained.',
  },
  {
    'title': 'Calligraphy',
    'content':
        'The calligraphy pen and chalk pen can be selected in the brush tool. The inclination of the pen can be adjusted. There are also templates for practicing calligraphy, which can be found under Import Image.',
  },
];

class TipOfTheDayDialog extends StatefulWidget {
  const TipOfTheDayDialog({super.key});

  @override
  State<TipOfTheDayDialog> createState() => _TipOfTheDayDialogState();
}

class _TipOfTheDayDialogState extends State<TipOfTheDayDialog> {
  int currentTipIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadTipIndex();
  }

  Future<void> _loadTipIndex() async {
    final prefs = await SharedPreferences.getInstance();
    final tipIndex = prefs.getInt('tipIndex') ?? 0;
    setState(() {
      currentTipIndex = tipIndex;
    });
  }

  Future<void> _incrementTipIndex() async {
    final prefs = await SharedPreferences.getInstance();
    final tipIndex = prefs.getInt('tipIndex') ?? 0;
    prefs.setInt('tipIndex', (tipIndex + 1) % tips.length);
    setState(() {
      currentTipIndex = (tipIndex + 1) % tips.length;
    });
  }

  Future<void> _closeTipDialog(BuildContext context) async {
    Navigator.of(context).pop();
    await _incrementTipIndex();
  }

  @override
  Widget build(BuildContext context) {
    final currentTip = tips[currentTipIndex];
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: PaintroidTheme.of(context).onSurfaceColor,
      titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tip of the Day',
            style: PaintroidTheme.of(context).titleTheme.titleMedium,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              await _closeTipDialog(context);
            },
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Divider(height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 100, child: AnimatedLightBulb()),
                const SizedBox(height: 16),
                Text(
                  currentTip['title']!,
                  textAlign: TextAlign.center,
                  style: PaintroidTheme.of(context).textTheme.bodyMedium!.apply(fontWeightDelta: 2),
                ),
                const SizedBox(height: 8),
                Text(
                  currentTip['content']!,
                  textAlign: TextAlign.center,
                  style: PaintroidTheme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      actions: [
        TextButton(
          onPressed: () async {
            await _closeTipDialog(context);
          },
          child: Text(
            'Close',
            style: TextStyle(color: PaintroidTheme.of(context).primaryColor),
          ),
        ),
        TextButton(
          onPressed: () async {
            await _incrementTipIndex();
          },
          child: Text(
            'Next',
            style: TextStyle(color: PaintroidTheme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}
