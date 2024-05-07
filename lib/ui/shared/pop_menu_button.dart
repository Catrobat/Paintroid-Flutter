// Flutter imports:
import 'package:flutter/material.dart';

class StyledPopMenuButton<T> extends StatelessWidget {
  final void Function(T) onSelected;
  final PopupMenuItemBuilder<T> itemBuilder;

  const StyledPopMenuButton({
    super.key,
    required this.onSelected,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context),
      child: PopupMenuButton<T>(
        color: Theme.of(context).colorScheme.background,
        icon: const Icon(Icons.more_vert, color: Colors.white),
        elevation: 7.0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0,
            color: Theme.of(context).colorScheme.background,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        onSelected: onSelected,
        itemBuilder: itemBuilder,
      ),
    );
  }
}
