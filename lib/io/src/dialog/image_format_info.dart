part of 'save_image_dialog.dart';

class ImageFormatInfo extends StatelessWidget {
  final ImageFormat format;

  const ImageFormatInfo(this.format, {Key? key}) : super(key: key);

  final _pngInfo =
      const TextSpan(text: "Lossless compression. Transparency is preserved");

  final _jpgInfo = const TextSpan(
    text: 'Takes up ',
    children: [
      TextSpan(
        text: 'minimal storage space.\nNo transparency ',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(text: 'is remembered.'),
    ],
  );

  @override
  Widget build(BuildContext context) {
    late TextSpan infoText;
    switch (format) {
      case ImageFormat.png:
        infoText = _pngInfo;
        break;
      case ImageFormat.jpg:
        infoText = _jpgInfo;
        break;
    }
    return Row(
      children: [
        const Icon(Icons.info_outline),
        const VerticalDivider(width: 8),
        Flexible(
          child: Text.rich(
            infoText,
            style: const TextStyle(fontSize: 11),
          ),
        )
      ],
    );
  }
}
