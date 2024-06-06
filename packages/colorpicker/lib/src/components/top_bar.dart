import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopBar extends ConsumerWidget {
  const TopBar({
    super.key,
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Container(
        height: 36.0,
        width: 36.0,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2.0),
          border: Border.all(
            color: Colors.white,
            width: 0.4,
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.check),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        const SizedBox(width: 10.0),
      ],
    );
  }
}
