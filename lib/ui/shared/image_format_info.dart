import 'package:flutter/material.dart';

import 'package:paintroid/core/enums/image_format.dart';
import 'package:paintroid/ui/theme/theme.dart';

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

  const ImageFormatInfo(this.format, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.info_outline, color: PaintroidTheme.of(context).shadowColor),
        VerticalDivider(
          width: 8,
          color: PaintroidTheme.of(context).shadowColor,
        ),
        Flexible(
          child: Text.rich(
            format.info,
            style: TextStyle(
              fontSize: 11,
              color: PaintroidTheme.of(context).shadowColor,
            ),
          ),
        )
      ],
    );
  }
}
