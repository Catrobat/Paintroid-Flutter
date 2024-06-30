import 'package:flutter/material.dart';

import 'package:paintroid/ui/theme/theme.dart';

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
        color: PaintroidTheme.of(context).backgroundColor,
        icon: Icon(
          Icons.more_vert,
          color: PaintroidTheme.of(context).onSurfaceColor,
        ),
        elevation: 7.0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0,
            color: PaintroidTheme.of(context).backgroundColor,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        onSelected: onSelected,
        itemBuilder: itemBuilder,
      ),
    );
  }
}
