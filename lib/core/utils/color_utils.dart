import 'package:flutter/material.dart';

extension ColorUtils on Color {
  int toValue() {
    final alpha = (a * 255).toInt();
    final red = (r * 255).toInt();
    final green = (g * 255).toInt();
    final blue = (b * 255).toInt();
    return (alpha << 24) | (red << 16) | (green << 8) | blue;
  }
}
