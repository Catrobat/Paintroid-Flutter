import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/tool/tool.dart';

import '../state/workspace_state_notifier.dart';
import 'draw_canvas.dart';

class Workspace extends ConsumerStatefulWidget {
  const Workspace({Key? key}) : super(key: key);

  @override
  ConsumerState<Workspace> createState() => _WorkspaceState();
}

class _WorkspaceState extends ConsumerState<Workspace> {
  @override
  Widget build(BuildContext context) {
    final toolStateNotifier = ref.watch(ToolState.provider.notifier);
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        border: Border.fromBorderSide(BorderSide(width: 0.5)),
      ),
      child: AspectRatio(
        aspectRatio: ref.watch(
          WorkspaceState.provider.select((state) => state.aspectRatio),
        ),
        child: GestureDetector(
          onPanDown: (details) {
            setState(() => toolStateNotifier.didTapDown(details.localPosition));
          },
          onPanUpdate: (details) {
            setState(() => toolStateNotifier.didDrag(details.localPosition));
          },
          onPanEnd: (_) {
            setState(() => toolStateNotifier.didTapUp());
          },
          // Cannot be const because it needs to be rebuilt on every setState call
          // ignore: prefer_const_constructors
          child: DrawCanvas(),
        ),
      ),
    );
  }
}
