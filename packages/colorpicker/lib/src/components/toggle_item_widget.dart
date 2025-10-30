import 'package:flutter/material.dart';

class ToggleItemWidget<T> extends StatelessWidget {
  final String text;
  final T currentMode;
  final T buttonMode;

  const ToggleItemWidget({
    super.key,
    required this.text,
    required this.currentMode,
    required this.buttonMode,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = currentMode == buttonMode;
    final colorScheme = Theme.of(context).colorScheme;
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
}
