import 'package:flutter/material.dart';
import 'package:paintroid/io/src/entity/image_location.dart';

Future<ImageLocation?> showLoadImageDialog(BuildContext context) =>
    showGeneralDialog<ImageLocation>(
        context: context,
        pageBuilder: (_, __, ___) => const LoadImageDialog(),
        barrierDismissible: true,
        barrierLabel: "Dismiss load image dialog box");

class LoadImageDialog extends StatefulWidget {
  const LoadImageDialog({Key? key}) : super(key: key);

  @override
  State<LoadImageDialog> createState() => _LoadImageDialogState();
}

class _LoadImageDialogState extends State<LoadImageDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Load image"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Where do you want to load the image from?"),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_photosButton, _filesButton],
          ),
        ],
      ),
    );
  }

  ElevatedButton get _photosButton {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).pop(ImageLocation.photos),
      child: const Text("Photos", style: TextStyle(color: Colors.white)),
    );
  }

  ElevatedButton get _filesButton {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).pop(ImageLocation.files),
      child: const Text("Files", style: TextStyle(color: Colors.white)),
    );
  }
}
