import 'package:flutter/material.dart';

class AdvancedOptionsDialog extends StatefulWidget {
  const AdvancedOptionsDialog({Key? key}) : super(key: key);

  @override
  AdvancedOptionsDialogState createState() => AdvancedOptionsDialogState();
}

class AdvancedOptionsDialogState extends State<AdvancedOptionsDialog> {
  bool _isSelectedOption1 = true;
  bool _isSelectedOption2 = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Advanced Options',
        style: TextStyle(color: Colors.blue),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Antialiasing',
                style: TextStyle(color: Colors.black),
              ),
              ToggleButtons(
                isSelected: [_isSelectedOption1],
                onPressed: (int index) {
                  setState(() {
                    _isSelectedOption1 = !_isSelectedOption1;
                  });
                },
                color: Colors.grey,
                fillColor: Colors.blue.shade50,
                children: <Widget>[
                  Icon(
                    _isSelectedOption1 ? Icons.toggle_on : Icons.toggle_off,
                    size: 45.0,
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Smoothing',
                style: TextStyle(color: Colors.black),
              ),
              ToggleButtons(
                isSelected: [_isSelectedOption2],
                onPressed: (int index) {
                  setState(() {
                    _isSelectedOption2 = !_isSelectedOption2;
                  });
                },
                color: Colors.grey,
                fillColor: Colors.blue.shade50,
                children: <Widget>[
                  Icon(
                    _isSelectedOption2 ? Icons.toggle_on : Icons.toggle_off,
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
