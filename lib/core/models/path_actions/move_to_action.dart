import 'package:json_annotation/json_annotation.dart';
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';
import 'package:paintroid/core/models/path_actions/path_action.dart';

part 'move_to_action.g.dart';

@JsonSerializable()
class MoveToAction extends PathAction {
  final double x;
  final double y;

  const MoveToAction(this.x, this.y);

  factory MoveToAction.fromJson(Map<String, dynamic> json) =>
      _$MoveToActionFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$MoveToActionToJson(this)..['type'] = SerializerType.MOVE_TO_ACTION;

  @override
  bool operator ==(Object other) =>
      other is MoveToAction && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);
}
