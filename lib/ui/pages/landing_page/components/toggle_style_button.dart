import 'package:flutter/material.dart';
import 'package:paintroid/ui/theme/data/paintroid_theme.dart';

class ToggleStyleButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const ToggleStyleButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
      fontWeight: FontWeight.bold,
      color: selected ? Colors.white : Colors.black,
    );

    if (label == 'U') {
      style = style.copyWith(decoration: TextDecoration.underline);
    } else if (label == 'I') {
      style = style.copyWith(fontStyle: FontStyle.italic);
    }

    return Material(
      color: selected
          ? PaintroidTheme.of(context).primaryColor
          : PaintroidTheme.of(context).onSurfaceColor,
      shape:
          const CircleBorder(side: BorderSide(color: Colors.black, width: 1.0)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 32,
          height: 32,
          child: Center(
            child: Text(
              label,
              style: style,
            ),
          ),
        ),
      ),
    );
  }
}
