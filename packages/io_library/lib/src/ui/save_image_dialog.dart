// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:component_library/component_library.dart';

// Project imports:
import 'package:io_library/io_library.dart';

/// Returns [null] if user dismissed the dialog by tapping outside
Future<ImageMetaData?> showSaveImageDialog(
        BuildContext context, bool savingProject) =>
    showGeneralDialog<ImageMetaData?>(
        context: context,
        pageBuilder: (_, __, ___) =>
            SaveImageDialog(savingProject: savingProject),
        barrierDismissible: true,
        barrierLabel: 'Dismiss save image dialog box');

class SaveImageDialog extends StatefulWidget {
  final bool savingProject;

  const SaveImageDialog({Key? key, required this.savingProject})
      : super(key: key);

  @override
  State<SaveImageDialog> createState() => _SaveImageDialogState();
}

class _SaveImageDialogState extends State<SaveImageDialog> {
  final TextEditingController nameFieldController = TextEditingController();
  final formKey = GlobalKey<FormState>(debugLabel: 'SaveImageDialog Form');
  var selectedFormat = ImageFormat.jpg;
  var imageQualityValue = 100;

  @override
  void initState() {
    super.initState();

    if (widget.savingProject) {
      selectedFormat = ImageFormat.catrobatImage;
    }
  }

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
    var dialogTitle = 'Save ';
    if (widget.savingProject) {
      dialogTitle += 'Project';
    } else {
      dialogTitle += 'Image';
    }
    return AlertDialog(
      title: Text(
        dialogTitle,
        style: PaintroidTheme.of(context).titleTheme.titleMedium,
      ),
      actions: [_cancelButton, _saveButton],
      contentTextStyle: PaintroidTheme.of(context).textTheme.bodyMedium,
      content: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _imageNameTextField,
            const Divider(height: 16),
            if (!widget.savingProject)
              Column(
                children: [
                  _imageFormatDropdown,
                  const Divider(height: 8),
                ],
              ),
            if (!widget.savingProject && selectedFormat == ImageFormat.jpg)
              Column(
                children: [
                  _qualitySlider,
                  const Divider(height: 8),
                ],
              ),
            ImageFormatInfo(selectedFormat),
          ],
        ),
      ),
    );
  }

  TextButton get _cancelButton {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text('Cancel'),
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
      child: const Text('Save'),
    );
  }

  Widget get _qualitySlider {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quality: $imageQualityValue%'),
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
      decoration: InputDecoration(
        hintText: widget.savingProject ? 'Project name' : 'Image name',
        hintStyle: PaintroidTheme.of(context).textTheme.bodySmall!.apply(
              color: PaintroidTheme.of(context).onSurfaceColor,
            ),
        filled: true,
        fillColor: PaintroidTheme.of(context).secondaryContainerColor,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
      validator: (text) {
        if (text == null || text.isEmpty) {
          var errMsg = 'Please specify an image name';
          if (widget.savingProject) {
            errMsg = 'Please specify a project name';
          }
          return errMsg;
        }
        return null;
      },
    );
  }

  Row get _imageFormatDropdown {
    return Row(
      children: [
        const Text('Format:'),
        const VerticalDivider(width: 12),
        DropdownButton<ImageFormat>(
          borderRadius: BorderRadius.circular(12),
          value: selectedFormat,
          underline: Divider(
            height: 0,
            color: PaintroidTheme.of(context).shadowColor,
          ),
          items: ImageFormat.values.map((fileType) {
            return DropdownMenuItem<ImageFormat>(
              value: fileType,
              child: Text(
                fileType.extension,
                style: PaintroidTheme.of(context).textTheme.bodyMedium,
              ),
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
