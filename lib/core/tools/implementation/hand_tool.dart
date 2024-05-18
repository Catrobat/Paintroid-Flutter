// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:equatable/equatable.dart';
// Project imports:
import 'package:paintroid/core/commands/command_factory/command_factory.dart';
import 'package:paintroid/core/commands/command_manager/command_manager.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/tool.dart';

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
  void onUp(Offset point) {}

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
      type: ToolType.HAND,
    );
  }
}
