import 'package:flutter/material.dart';
import 'package:paintroid/ui/theme/theme.dart';

enum ImportSource { gallery, stickers }

Future<ImportSource?> showImportImageDialog(BuildContext context) =>
    showGeneralDialog<ImportSource>(
        context: context,
        pageBuilder: (context, _, __) => AlertDialog(
              backgroundColor: PaintroidTheme.of(context).onSurfaceColor,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2.0))),
              title: Text(
                'Import image',
                style: TextStyle(color: PaintroidTheme.of(context).shadowColor),
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(ImportSource.gallery),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.image,
                            size: 48,
                            color: PaintroidTheme.of(context).shadowColor,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Gallery',
                            style: TextStyle(
                                color: PaintroidTheme.of(context).shadowColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(ImportSource.stickers),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.emoji_emotions,
                            size: 48,
                            color: PaintroidTheme.of(context).shadowColor,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Stickers',
                            style: TextStyle(
                                color: PaintroidTheme.of(context).shadowColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      color: PaintroidTheme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
        barrierDismissible: true,
        barrierLabel: 'Dismiss import image dialog box');
