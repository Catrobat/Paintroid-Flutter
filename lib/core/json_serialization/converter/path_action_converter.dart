import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:paintroid/core/commands/path_with_action_history.dart';
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';

class PathActionConverter
    implements JsonConverter<PathAction, Map<String, dynamic>> {
  const PathActionConverter();

  @override
  PathAction fromJson(Map<String, dynamic> json) {
    switch (json['type'] as String) {
      case SerializerType.MOVE_TO_ACTION:
        return MoveToAction(
          (json['x'] as num).toDouble(),
          (json['y'] as num).toDouble(),
        );
      case SerializerType.LINE_TO_ACTION:
        return LineToAction(
          (json['x'] as num).toDouble(),
          (json['y'] as num).toDouble(),
        );
      case SerializerType.QUAD_TO_ACTION:
        return QuadToAction(
          (json['x1'] as num).toDouble(),
          (json['y1'] as num).toDouble(),
          (json['x2'] as num).toDouble(),
          (json['y2'] as num).toDouble(),
        );
      case SerializerType.CUBIC_TO_ACTION:
        return CubicToAction(
          (json['x1'] as num).toDouble(),
          (json['y1'] as num).toDouble(),
          (json['x2'] as num).toDouble(),
          (json['y2'] as num).toDouble(),
          (json['x3'] as num).toDouble(),
          (json['y3'] as num).toDouble(),
        );
      case SerializerType.CLOSE_ACTION:
        return const CloseAction();
      default:
        return const CloseAction();
    }
  }

  @override
  Map<String, dynamic> toJson(PathAction action) {
    switch (action.runtimeType) {
      case == MoveToAction:
        action as MoveToAction;
        return {
          'type': SerializerType.MOVE_TO_ACTION,
          'x': action.x,
          'y': action.y,
        };
      case == LineToAction:
        action as LineToAction;
        return {
          'type': SerializerType.LINE_TO_ACTION,
          'x': action.x,
          'y': action.y,
        };
      case == QuadToAction:
        action as QuadToAction;
        return {
          'type': SerializerType.QUAD_TO_ACTION,
          'x1': action.x1,
          'y1': action.y1,
          'x2': action.x2,
          'y2': action.y2,
        };
      case == CubicToAction:
        action as CubicToAction;
        return {
          'type': SerializerType.CUBIC_TO_ACTION,
          'x1': action.x1,
          'y1': action.y1,
          'x2': action.x2,
          'y2': action.y2,
          'x3': action.x3,
          'y3': action.y3,
        };
      default:
        return {'type': SerializerType.CLOSE_ACTION};
    }
  }
}
