import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';

class AdvancedOptionsDialog extends StatefulWidget {
  const AdvancedOptionsDialog({Key? key}) : super(key: key);

  @override
  AdvancedOptionsDialogState createState() => AdvancedOptionsDialogState();
}

class AdvancedOptionsDialogState extends State<AdvancedOptionsDialog> {
  bool _isAntialiasingSelected = true;
  bool _isSmoothingSelected = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Advanced Options',
        style: TextStyle(color: lightColorScheme.tertiary),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Antialiasing',
                style: TextStyle(color: lightColorScheme.onBackground),
              ),
              ToggleButtons(
                isSelected: [_isAntialiasingSelected],
                onPressed: (int index) {
                  setState(() {
                    _isAntialiasingSelected = !_isAntialiasingSelected;
                  });
                },
                color: lightColorScheme.onSurfaceVariant,
                fillColor: lightColorScheme.onPrimaryContainer,
                children: <Widget>[
                  Icon(
                    _isAntialiasingSelected
                        ? Icons.toggle_on
                        : Icons.toggle_off,
                    size: 45.0,
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Smoothing',
                style: TextStyle(color: lightColorScheme.onBackground),
              ),
              ToggleButtons(
                isSelected: [_isSmoothingSelected],
                onPressed: (int index) {
                  setState(() {
                    _isSmoothingSelected = !_isSmoothingSelected;
                  });
                },
                color: lightColorScheme.onSurfaceVariant,
                fillColor: lightColorScheme.onPrimaryContainer,
                children: <Widget>[
                  Icon(
                    _isSmoothingSelected ? Icons.toggle_on : Icons.toggle_off,
                    size: 45.0,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
