import 'package:flutter/material.dart';
import 'package:workspace_screen/workspace_screen.dart';

class ToolOptions extends StatelessWidget {
  const ToolOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          TopBrushToolOptions(),
          Spacer(),
          BottomBrushToolOptions(),
        ],
      ),
    );
  }
}
