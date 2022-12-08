import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

@visibleForTesting
class ImageWithPixelInfo {
  final ByteData _byteData;
  final int _width;
  final int _height;

  const ImageWithPixelInfo._(this._width, this._height, this._byteData);

  static Future<ImageWithPixelInfo> initialize(Image image) async {
    final data = await image.toByteData();
    return ImageWithPixelInfo._(image.width, image.height, data!);
  }

  /// Range: (-1, -1) → (1, 1)
  Color pixelColorFor(Alignment alignment) {
    final size = Size(_width.toDouble() - 1.0, _height.toDouble() - 1.0);
    final offset = alignment.alongSize(size);
    return pixelColorAt(offset.dx.round(), offset.dy.round());
  }

  /// Range: (0,0) → (width-1, height-1)
  Color pixelColorAt(int x, int y) {
    if (x < 0 || x >= _width || y < 0 || y >= _height) {
      throw "Failed to calculate color due to"
          "invalid coordinates: ($x, $y) don't fit inside $_width x $_height";
    }
    final byteOffset = 4 * (x + (y * _width));
    return Color(_rgbaToArgb(_byteData.getUint32(byteOffset)));
  }

  int _rgbaToArgb(int rgbaColor) {
    int a = rgbaColor & 0xFF;
    int rgb = rgbaColor >> 8;
    return rgb + (a << 24);
  }
}

extension AlignmentValues on Alignment {
  static Iterable<Alignment> get values => const [
        Alignment.bottomLeft,
        Alignment.bottomCenter,
        Alignment.bottomRight,
        Alignment.centerLeft,
        Alignment.center,
        Alignment.centerRight,
        Alignment.topLeft,
        Alignment.topCenter,
        Alignment.topRight,
      ];
}
