import 'package:flutter/material.dart';
import 'package:paintroid/ui/theme/data/paintroid_theme.dart';

class ActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String valueKey;

  const ActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.valueKey,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        key: ValueKey(valueKey),
        icon: Icon(icon),
        onPressed: onPressed,
        disabledColor:
            PaintroidTheme.of(context).onSurfaceColor.withOpacity(0.4),
        color: PaintroidTheme.of(context).onSurfaceColor,
      ),
    );
  }
}
