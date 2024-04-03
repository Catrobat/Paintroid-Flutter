// Package imports:
import 'package:equatable/equatable.dart';
import 'package:io_library/io_library.dart';

// Project imports:
import 'package:command/command.dart';

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
