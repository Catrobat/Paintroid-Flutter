import 'dart:ui' as ui;
import 'package:colorpicker/src/constants/colorpicker_colors.dart';
import 'package:flutter/material.dart';

class PipettePage extends StatefulWidget {
  final ui.Image snapshot;
  final Color initialColor;

  const PipettePage({
    super.key,
    required this.snapshot,
    required this.initialColor,
  });

  @override
  State<PipettePage> createState() => _PipettePageState();
}

class _PipettePageState extends State<PipettePage> {
  Offset? _currentPosition;
  Color _selectedColor = Colors.transparent;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
  }

  void _updatePosition(Offset position, Size size) {
    if (_isProcessing) return;
    setState(() {
      _currentPosition = position;
    });
    _getColorAt(position, size);
  }

  Future<void> _getColorAt(Offset position, Size size) async {
    _isProcessing = true;
    final image = widget.snapshot;

    double imageScale = 1.0;
    double offsetX = 0.0;
    double offsetY = 0.0;

    final double screenAspect = size.width / size.height;
    final double imageAspect = image.width / image.height;

    if (imageAspect > screenAspect) {
      imageScale = size.width / image.width;
      offsetY = (size.height - image.height * imageScale) / 2;
    } else {
      imageScale = size.height / image.height;
      offsetX = (size.width - image.width * imageScale) / 2;
    }

    final double imageX = (position.dx - offsetX) / imageScale;
    final double imageY = (position.dy - offsetY) / imageScale;

    if (imageX < 0 ||
        imageY < 0 ||
        imageX >= image.width ||
        imageY >= image.height) {
      _isProcessing = false;
      return;
    }

    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) {
      _isProcessing = false;
      return;
    }

    if (!mounted) return;

    final int x = imageX.toInt();
    final int y = imageY.toInt();
    final int offset = (y * image.width + x) * 4;

    if (offset + 3 < byteData.lengthInBytes) {
      final int r = byteData.getUint8(offset);
      final int g = byteData.getUint8(offset + 1);
      final int b = byteData.getUint8(offset + 2);
      final int a = byteData.getUint8(offset + 3);
      setState(() {
        _selectedColor = Color.fromARGB(a, r, g, b);
      });
    }
    _isProcessing = false;
  }

  Future<bool> _showExitDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Save changes?'),
            content: const Text('Do you want to save your changes?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('NO'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('YES'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: ColorPickerColors.oceanBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            if (_selectedColor != widget.initialColor) {
              final save = await _showExitDialog();
              if (!context.mounted) return;
              if (save) {
                Navigator.pop(context, _selectedColor);
              } else {
                Navigator.pop(context);
              }
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage(
                  'assets/img/checkerboard.png',
                  package: 'colorpicker',
                ),
                repeat: ImageRepeat.repeat,
              ),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: _selectedColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () => Navigator.pop(context, _selectedColor),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          return GestureDetector(
            onPanStart: (details) =>
                _updatePosition(details.localPosition, size),
            onPanUpdate: (details) =>
                _updatePosition(details.localPosition, size),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/img/checkerboard.png',
                    package: 'colorpicker',
                    repeat: ImageRepeat.repeat,
                  ),
                ),
                Positioned.fill(
                  child: RawImage(
                    image: widget.snapshot,
                    fit: BoxFit.contain,
                  ),
                ),
                if (_currentPosition != null)
                  Positioned(
                    left: _currentPosition!.dx - 50,
                    top: _currentPosition!.dy - 120,
                    child: _buildLoupe(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoupe() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipOval(
        child: Container(
          color: _selectedColor,
          child: Center(
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
