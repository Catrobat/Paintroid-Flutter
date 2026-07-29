import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:colorpicker/src/constants/colorpicker_colors.dart';
import 'package:flutter/material.dart';

class PipettePage extends StatefulWidget {
  final ui.Image snapshot;
  final Color initialColor;
  final String saveChangesTitle;
  final String saveChangesContent;
  final String noLabel;
  final String yesLabel;

  const PipettePage({
    super.key,
    required this.snapshot,
    required this.initialColor,
    this.saveChangesTitle = 'Save changes?',
    this.saveChangesContent = 'Do you want to save your changes?',
    this.noLabel = 'NO',
    this.yesLabel = 'YES',
  });

  @override
  State<PipettePage> createState() => _PipettePageState();
}

class _PipettePageState extends State<PipettePage> {
  Offset? _currentPosition;
  Color _selectedColor = Colors.transparent;
  bool _isProcessing = false;
  ByteData? _imageBytes;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
    _loadImageBytes();
  }

  Future<void> _loadImageBytes() async {
    final byteData =
        await widget.snapshot.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (mounted) {
      setState(() {
        _imageBytes = byteData;
      });
    }
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

    final byteData = _imageBytes;
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
            title: Text(widget.saveChangesTitle),
            content: Text(widget.saveChangesContent),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(widget.noLabel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(widget.yesLabel),
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
    return Stack(
      alignment: Alignment.center,
      children: [
        const RawMagnifier(
          decoration: MagnifierDecoration(
            shape: CircleBorder(
              side: BorderSide(
                color: Colors.white,
                width: 3,
              ),
            ),
          ),
          size: Size(100, 100),
          magnificationScale: 2.0,
          focalPointOffset: Offset(0, 70),
        ),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1),
          ),
        ),
      ],
    );
  }
}
