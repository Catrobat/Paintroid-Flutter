import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:paintroid/core/providers/state/toolbox_state_provider.dart';
import 'package:paintroid/core/tools/tool_data.dart';
import 'package:paintroid/ui/shared/icon_button_with_label.dart';
import 'package:paintroid/ui/shared/icon_svg.dart';
import 'package:paintroid/ui/theme/theme.dart';

import 'package:paintroid/core/localization/app_localizations.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/ui/shared/dialogs/import_image_dialog.dart';
import 'package:paintroid/ui/pages/workspace_page/components/import_tool/stickers_gallery_page.dart';
import 'package:paintroid/core/providers/object/tools/import_tool_provider.dart';
import 'package:paintroid/core/providers/object/load_image_from_photo_library.dart';
import 'package:paintroid/core/providers/object/canvas_painter_provider.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'dart:ui' as ui;

class ToolButton extends StatelessWidget {
  final ToolData toolData;

  const ToolButton({
    super.key,
    required this.toolData,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Consumer(
      builder: (context, ref, child) {
        return SizedBox(
          width: 50.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 8.0,
            ),
            child: IconButtonWithLabel(
              icon: IconSvg(
                path: toolData.svgAssetPath,
                height: 30.0,
                width: 30.0,
                color: PaintroidTheme.of(context).onSurfaceColor,
              ),
              label: toolData.type.localizedName(localizations),
              key: ValueKey(toolData.name),
              onPressed: () async {
                final toolboxNotifier = ref.read(toolBoxStateProvider.notifier);
                final importTool = ref.read(importToolProvider);
                final canvasNotifier = ref.read(canvasPainterProvider.notifier);
                final photoLibrary = ref.read(LoadImageFromPhotoLibrary.provider);
                final canvasSize = ref.read(canvasStateProvider).size;
                final navigator = Navigator.of(context);

                navigator.pop();

                if (toolData.type == ToolType.IMPORT) {
                  final source = await showImportImageDialog(context);
                  if (source == null) return;
                  if (source == ImportSource.gallery) {
                    toolboxNotifier.switchTool(toolData);
                    await importTool.pickImage(photoLibrary, canvasSize);
                    canvasNotifier.repaint();
                  } else if (source == ImportSource.stickers) {
                    final ui.Image? image = await navigator.push<ui.Image>(
                      MaterialPageRoute(
                        builder: (_) => const StickersGalleryPage(),
                      ),
                    );
                    if (image != null) {
                      toolboxNotifier.switchTool(toolData);
                      importTool.setImage(image, canvasSize);
                      canvasNotifier.repaint();
                    }
                  }
                } else {
                  toolboxNotifier.switchTool(toolData);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
