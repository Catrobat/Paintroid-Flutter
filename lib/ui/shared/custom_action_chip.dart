import 'package:flutter/material.dart';

class CustomActionChip extends StatelessWidget {
  final Widget chipIcon;
  final VoidCallback? onPressed;
  final OutlinedBorder? shape;
  final Color chipBackgroundColor;
  final EdgeInsetsGeometry? padding;
  final MaterialTapTargetSize? materialTapTargetSize;
  final String hint;

  const CustomActionChip({
    super.key,
    required this.chipIcon,
    required this.onPressed,
    required this.chipBackgroundColor,
    required this.hint,
    this.shape,
    this.padding,
    this.materialTapTargetSize,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      tooltip: hint,
      label: chipIcon,
      onPressed: onPressed,
      shape: shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
      disabledColor: chipBackgroundColor.withValues(alpha: 0.9),
      backgroundColor: chipBackgroundColor,
      padding: padding ?? const EdgeInsets.fromLTRB(8, 0, 8, 0),
      materialTapTargetSize:
          materialTapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
    );
  }
}
