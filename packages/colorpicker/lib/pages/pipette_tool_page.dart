import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:colorpicker/src/components/top_bar.dart';
import 'package:colorpicker/src/state/color_picker_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PipetteToolPage extends ConsumerStatefulWidget {
  const PipetteToolPage({
    super.key,
    required this.snapshot,
  });

  final ui.Image? snapshot;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PipetteToolPageState();
}

class _PipetteToolPageState extends ConsumerState<PipetteToolPage> {
  GlobalKey imageKey = GlobalKey();
  ui.Image? displayImage;

  Future<void> _loadImage() async {
    final ByteData? bytedata =
        await widget.snapshot!.toByteData(format: ui.ImageByteFormat.png);
    if (bytedata == null) {
      return Future.error('An error occurred while loading the snapshot');
    }
    final Uint8List headedIntList = Uint8List.view(bytedata.buffer);
    ImageProvider? image = MemoryImage(headedIntList);
    final ImageStream imageStream = image.resolve(const ImageConfiguration());
    final Completer<ui.Image> completer = Completer<ui.Image>();

    void imageListener(ImageInfo info, bool synchronousCall) {
      completer.complete(info.image);
      imageStream.removeListener(ImageStreamListener(imageListener));
    }

    imageStream.addListener(ImageStreamListener(imageListener));
    displayImage = await completer.future;

    setState(() {});
  }

  Future<void> _updateColor(TapUpDetails details) async {
    RenderBox box = imageKey.currentContext!.findRenderObject() as RenderBox;
    Offset localPosition = box.globalToLocal(details.globalPosition);

    double xRatio = localPosition.dx / box.size.width;
    double yRatio = localPosition.dy / box.size.height;

    int x = (xRatio * displayImage!.width).toInt();
    int y = (yRatio * displayImage!.height).toInt();

    ByteData? byteData =
        await displayImage!.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) return;

    int offset = (y * displayImage!.width + x) * 4;

    int red = byteData.getUint8(offset);
    int green = byteData.getUint8(offset + 1);
    int blue = byteData.getUint8(offset + 2);
    int alpha = byteData.getUint8(offset + 3);

    Color color = Color.fromARGB(alpha, red, green, blue);

    final colorData = ref.read(colorPickerStateProvider.notifier);
    colorData.updateColor(color.withOpacity(1));
    colorData.updateOpacity(color.opacity);
  }

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final colorData = ref.watch(colorPickerStateProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: TopBar(
            color: colorData.currentColor != null
                ? colorData.currentColor!.withOpacity(colorData.currentOpacity)
                : Colors.transparent),
      ),
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'packages/colorpicker/assets/img/checkerboard.png',
                repeat: ImageRepeat.repeat,
                cacheHeight: 16,
                cacheWidth: 16,
                filterQuality: FilterQuality.none,
              ),
            ),
            if (displayImage != null)
              GestureDetector(
                onTapUp: _updateColor,
                child: SizedBox(
                  height: screenSize.height,
                  width: screenSize.width,
                  child: CustomPaint(
                    key: imageKey,
                    painter: ImagePainter(displayImage!),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ImagePainter extends CustomPainter {
  final ui.Image image;

  ImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect srcRect =
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final Rect dstRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(image, srcRect, dstRect, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
