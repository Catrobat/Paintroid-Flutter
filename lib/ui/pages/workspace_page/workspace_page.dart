// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/providers/state/tools/toolbox/toolbox_state_provider.dart';
import 'package:paintroid/core/tools/text_tool/text_tool.dart';
import 'package:paintroid/core/tools/tool.dart';
import 'package:toast/toast.dart';

// Project imports:
import 'package:paintroid/core/providers/object/io_handler.dart';
import 'package:paintroid/core/providers/state/workspace_state_notifier.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/bottom_nav_bar.dart';
import 'package:paintroid/ui/pages/workspace_page/components/bottom_bar/tool_options/tool_options.dart';
import 'package:paintroid/ui/pages/workspace_page/components/drawing_surface/drawing_canvas.dart';
import 'package:paintroid/ui/pages/workspace_page/components/drawing_surface/exit_fullscreen_button.dart';
import 'package:paintroid/ui/pages/workspace_page/components/top_bar/top_app_bar.dart';
import 'package:paintroid/ui/shared/dialogs/discard_changes_dialog.dart';

class WorkspacePage extends ConsumerStatefulWidget {
  const WorkspacePage({super.key});

  @override
  ConsumerState<WorkspacePage> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends ConsumerState<WorkspacePage> {
  void _toggleStatusBar(bool isFullscreen) {
    SystemChrome.setEnabledSystemUIMode(
      isFullscreen ? SystemUiMode.immersiveSticky : SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );
  }

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    final isFullscreen = ref.watch(
      WorkspaceState.provider.select((state) => state.isFullscreen),
    );
    ref.listen<bool>(
      WorkspaceState.provider.select((state) => state.isFullscreen),
      (_, isFullscreen) => _toggleStatusBar(isFullscreen),
    );
    final ioHandler = ref.watch(IOHandler.provider);
    final workspaceStateNotifier = ref.watch(WorkspaceState.provider.notifier);
    final selectedTool = ref.watch(toolBoxStateProvider).currentTool;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        if (isFullscreen) {
          workspaceStateNotifier.toggleFullscreen(false);
          return;
        }
        if (!workspaceStateNotifier.hasSavedLastWork) {
          final shouldDiscard = await showDiscardChangesDialog(context);
          if (shouldDiscard != null && !shouldDiscard && context.mounted) {
            bool savedImage = await ioHandler.saveImage(context);
            if (!savedImage) {
              return;
            }
          }
        }
        if (!context.mounted) return;
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: isFullscreen ? null : const TopAppBar(title: 'Pocket Paint'),
        backgroundColor: Colors.grey.shade400,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            const DrawingCanvas(),
            if (isFullscreen)
              const Positioned(
                top: 2,
                right: 2,
                child: SafeArea(child: ExitFullscreenButton()),
              )
            else
              const ToolOptions(),
            if (selectedTool is TextTool && selectedTool.isEditing)
              Positioned(
                left: selectedTool.currentPosition?.dx ?? 0,
                top: selectedTool.currentPosition?.dy ?? 0,
                child: Draggable(
                  feedback: Material(
                    color: Colors.transparent,
                    child: buildTextInput(),
                  ),
                  childWhenDragging: Container(),
                  onDraggableCanceled: (_, offset) {
                    selectedTool.onDrag(offset);
                    setState(() {});
                  },
                  child: buildTextInput(),
                ),
              ),
          ],
        ),
        bottomNavigationBar: isFullscreen ? null : const BottomNavBar(),
      ),
    );
  }

  Widget buildTextInput() {
    return Container(
      padding: const EdgeInsets.all(2),
      width: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5),
        // color: Colors.white,
      ),
      child: TextField(
        controller: textController,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Enter text',
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        onChanged: (value) {
          Tool currentTool = ref.read(toolBoxStateProvider).currentTool;
          currentTool is TextTool ? currentTool.currentText = value : null;
        },
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
