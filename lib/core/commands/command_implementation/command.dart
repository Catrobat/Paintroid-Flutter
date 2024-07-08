import 'package:equatable/equatable.dart';

import 'package:paintroid/core/commands/command_implementation/graphic/line_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/path_command.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shapes_command.dart';
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';

abstract class Command with EquatableMixin {
  const Command();

  Map<String, dynamic> toJson();

  factory Command.fromJson(Map<String, dynamic> json) {
    String type = json['type'] as String;
    switch (type) {
      case SerializerType.PATH_COMMAND:
        return PathCommand.fromJson(json);
      case SerializerType.LINE_COMMAND:
        return LineCommand.fromJson(json);
      case SerializerType.SHAPES_COMMAND:
        return ShapesCommand.fromJson(json);
      default:
        return PathCommand.fromJson(json);
    }
  }
}
