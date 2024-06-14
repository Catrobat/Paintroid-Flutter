// Dart imports:
import 'dart:math';

class DistanceCalculator {
  static double calculateDistanceBetweenTwoPoints(
      double x0, double y0, double x1, double y1) {
    return sqrt(pow(x1 - x0, 2) + pow(y1 - y0, 2));
  }
}
