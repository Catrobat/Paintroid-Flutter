import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:paintroid/command/src/command_factory.dart';
import 'package:paintroid/command/src/command_manager.dart';
import 'package:paintroid/core/graphic_factory.dart';
import 'package:paintroid/tool/src/tool.dart';
import 'package:paintroid/tool/src/tool_types.dart';

class HandTool extends Tool with EquatableMixin {
  HandTool({
    required super.paint,
    required super.commandFactory,
    required super.commandManager,
    required super.type,
  });

  @override
  void onDown(Offset point) {}

  @override
  void onDrag(Offset point) {}

  @override
  void onUp(Offset? point) {}

  @override
  void onCancel() {}

  @override
  List<Object?> get props => [commandManager, commandFactory];

  HandTool copyWith({
    Paint? paint,
    CommandFactory? commandFactory,
    CommandManager? commandManager,
    GraphicFactory? graphicFactory,
    ToolType? type,
  }) {
    return HandTool(
      paint: paint ?? this.paint,
      commandFactory: commandFactory ?? this.commandFactory,
      commandManager: commandManager ?? this.commandManager,
      type: type ?? this.type,
    );
  }
}
