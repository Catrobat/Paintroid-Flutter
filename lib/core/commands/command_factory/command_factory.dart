// Dart imports:
import 'dart:ui';

// Project imports:
import 'package:paintroid/core/commands/command_implementation/graphic/line_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/path_command.dart';
import 'package:paintroid/core/commands/path_with_action_history.dart';

import 'package:paintroid/core/commands/command_implementation/add_text_command.dart';
import 'package:paintroid/core/commands/command_implementation/finalize_text_command.dart';

class CommandFactory {
  const CommandFactory();

  PathCommand createPathCommand(
    PathWithActionHistory path,
    Paint paint,
  ) =>
      PathCommand(path, paint);

  LineCommand createLineCommand(
    PathWithActionHistory path,
    Paint paint,
    Offset startPoint,
    Offset endPoint,
  ) =>
      LineCommand(path, paint, startPoint, endPoint);

  AddTextCommand createAddTextCommand(
    Offset point,
    String text,
    Paint paint,
  ) =>
      AddTextCommand(point, text, paint);
}
