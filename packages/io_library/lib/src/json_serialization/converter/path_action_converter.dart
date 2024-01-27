import 'package:command/command.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:io_library/io_library.dart';

class PathActionConverter
    implements JsonConverter<PathAction, Map<String, dynamic>> {
  const PathActionConverter();

  @override
  PathAction fromJson(Map<String, dynamic> json) {
    switch (json['type'] as String) {
      case SerializerType.MOVE_TO_ACTION:
        return MoveToAction(json['x'] as double, json['y'] as double);
      case SerializerType.LINE_TO_ACTION:
        return LineToAction(json['x'] as double, json['y'] as double);
      case SerializerType.CLOSE_ACTION:
        return const CloseAction();
      default:
        return const CloseAction();
    }
  }

  @override
  Map<String, dynamic> toJson(PathAction action) {
    if (action is MoveToAction) {
      return {
        'type': SerializerType.MOVE_TO_ACTION,
        'x': action.x,
        'y': action.y
      };
    } else if (action is LineToAction) {
      return {
        'type': SerializerType.LINE_TO_ACTION,
        'x': action.x,
        'y': action.y
      };
    } else {
      return {'type': SerializerType.CLOSE_ACTION};
    }
  }
}
