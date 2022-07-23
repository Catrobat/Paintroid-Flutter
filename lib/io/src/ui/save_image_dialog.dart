import 'package:flutter/material.dart';
import 'package:paintroid/io/io.dart';

part 'image_format_info.dart';

/// Returns null if user dismissed the dialog by tapping outside
Future<ImageMetaData?> showSaveImageDialog(BuildContext context) =>
    showGeneralDialog<ImageMetaData?>(
        context: context,
        pageBuilder: (_, __, ___) => const SaveImageDialog(),
        barrierDismissible: true,
        barrierLabel: "Dismiss save image dialog box");

class SaveImageDialog extends StatefulWidget {
  const SaveImageDialog({Key? key}) : super(key: key);

  @override
  State<SaveImageDialog> createState() => _SaveImageDialogState();
}

class _SaveImageDialogState extends State<SaveImageDialog> {
  final nameFieldController = TextEditingController(text: "image");
  final formKey = GlobalKey<FormState>(debugLabel: "SaveImageDialog Form");
  var selectedFormat = ImageFormat.jpg;
  var imageQualityValue = 100;

  void _dismissDialogWithData() {
    late ImageMetaData data;
    switch (selectedFormat) {
      case ImageFormat.png:
        data = PngMetaData(nameFieldController.text);
        break;
      case ImageFormat.jpg:
        data = JpgMetaData(nameFieldController.text, imageQualityValue);
        break;
      case ImageFormat.catrobatImage:
        data = CatrobatImageMetaData(nameFieldController.text);
        break;
    }
    Navigator.of(context).pop(data);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Save image"),
      actions: [_cancelButton, _saveButton],
      contentTextStyle: Theme.of(context).textTheme.bodyLarge,
      content: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _imageNameTextField,
            const Divider(height: 16),
            _imageFormatDropdown,
            const Divider(height: 8),
            if (selectedFormat == ImageFormat.jpg) _qualitySlider,
            const Divider(height: 8),
            ImageFormatInfo(selectedFormat),
          ],
        ),
      ),
    );
  }

  TextButton get _cancelButton {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text("Cancel"),
    );
  }

  TextButton get _saveButton {
    return TextButton(
      onPressed: () {
        final formState = formKey.currentState;
        if (formState != null && formState.validate()) {
          _dismissDialogWithData();
        }
      },
      child: const Text("Save"),
    );
  }

  Widget get _qualitySlider {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Quality: $imageQualityValue%"),
            Slider(
              max: 100,
              divisions: 100,
              value: imageQualityValue.toDouble(),
              onChanged: (newValue) {
                setState(() => imageQualityValue = newValue.toInt());
              },
            ),
          ],
        );
      },
    );
  }

  TextFormField get _imageNameTextField {
    return TextFormField(
      controller: nameFieldController,
      decoration: const InputDecoration(labelText: "Name", filled: true),
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Please specify an image name';
        }
        return null;
      },
    );
  }

  Row get _imageFormatDropdown {
    return Row(
      children: [
        const Text("Format:"),
        const VerticalDivider(width: 12),
        DropdownButton<ImageFormat>(
          borderRadius: BorderRadius.circular(12),
          value: selectedFormat,
          underline: const Divider(height: 0, color: Colors.black),
          items: ImageFormat.values.map((fileType) {
            return DropdownMenuItem<ImageFormat>(
              value: fileType,
              child: Text(fileType.extension),
            );
          }).toList(),
          onChanged: (selectedFileType) {
            if (selectedFileType != null) {
              setState(() => selectedFormat = selectedFileType);
            }
          },
        ),
      ],
    );
  }
}
