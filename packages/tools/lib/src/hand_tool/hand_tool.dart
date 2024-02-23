import 'dart:ui';

import 'package:command/command.dart';
import 'package:equatable/equatable.dart';
import 'package:tools/tools.dart';

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
