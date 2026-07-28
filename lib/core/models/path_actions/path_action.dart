import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';
import 'package:paintroid/core/models/path_actions/move_to_action.dart';
import 'package:paintroid/core/models/path_actions/line_to_action.dart';
import 'package:paintroid/core/models/path_actions/close_action.dart';

abstract class PathAction {
  const PathAction();

  factory PathAction.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case SerializerType.MOVE_TO_ACTION:
        return MoveToAction.fromJson(json);
      case SerializerType.LINE_TO_ACTION:
        return LineToAction.fromJson(json);
      case SerializerType.CLOSE_ACTION:
        return const CloseAction();
      default:
        return const CloseAction();
    }
  }

  Map<String, dynamic> toJson();
}
