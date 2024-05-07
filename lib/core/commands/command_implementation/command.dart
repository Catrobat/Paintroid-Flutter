// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:paintroid/core/commands/command_implementation/graphic/draw_path_command.dart';
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';

abstract class Command with EquatableMixin {
  const Command();

  Map<String, dynamic> toJson();

  factory Command.fromJson(Map<String, dynamic> json) {
    String type = json['type'] as String;
    switch (type) {
      case SerializerType.DRAW_PATH_COMMAND:
        return DrawPathCommand.fromJson(json);
      default:
        return DrawPathCommand.fromJson(json);
    }
  }
}
