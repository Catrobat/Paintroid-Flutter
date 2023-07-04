import 'package:flutter/material.dart';

class CustomActionChip extends StatelessWidget {
  final Icon chipIcon;
  final VoidCallback onPressed;
  final OutlinedBorder? shape;
  final Color chipBackgroundColor;
  final EdgeInsetsGeometry? padding;
  final MaterialTapTargetSize? materialTapTargetSize;

  const CustomActionChip({
    super.key,
    required this.chipIcon,
    required this.onPressed,
    required this.chipBackgroundColor,
    this.shape,
    this.padding,
    this.materialTapTargetSize,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: chipIcon,
      onPressed: onPressed,
      shape: shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
      backgroundColor: chipBackgroundColor,
      padding: padding ?? const EdgeInsets.fromLTRB(8, 0, 8, 0),
      materialTapTargetSize:
          materialTapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
    );
  }
}
