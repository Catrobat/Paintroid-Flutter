// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:paintroid/core/models/enums/image_format.dart';

extension on ImageFormat {
  TextSpan get info {
    switch (this) {
      case ImageFormat.png:
        return const TextSpan(
            text: 'Lossless compression. Transparency is preserved');
      case ImageFormat.jpg:
        return const TextSpan(
          text: 'Takes up ',
          children: [
            TextSpan(
              text: 'minimal storage space.\nNo transparency ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: 'is remembered.'),
          ],
        );
      case ImageFormat.catrobatImage:
        return const TextSpan(
            text: 'Pocket Paint\'s native image format. '
                'This format remembers commands and layers.');
    }
  }
}

class ImageFormatInfo extends StatelessWidget {
  final ImageFormat format;

  const ImageFormatInfo(this.format, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.info_outline),
        const VerticalDivider(width: 8),
        Flexible(
          child: Text.rich(
            format.info,
            style: const TextStyle(fontSize: 11),
          ),
        )
      ],
    );
  }
}
