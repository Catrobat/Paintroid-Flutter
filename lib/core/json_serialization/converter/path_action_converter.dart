// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:paintroid/core/commands/utils/path_with_action_history.dart';
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';

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
    switch (action.runtimeType) {
      case MoveToAction:
        action as MoveToAction;
        return {
          'type': SerializerType.MOVE_TO_ACTION,
          'x': action.x,
          'y': action.y,
        };
      case LineToAction:
        action as LineToAction;
        return {
          'type': SerializerType.LINE_TO_ACTION,
          'x': action.x,
          'y': action.y,
        };
      default:
        return {'type': SerializerType.CLOSE_ACTION};
    }
  }
}
