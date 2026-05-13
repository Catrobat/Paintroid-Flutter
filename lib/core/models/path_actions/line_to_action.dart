import 'package:json_annotation/json_annotation.dart';
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';
import 'package:paintroid/core/models/path_actions/path_action.dart';

part 'line_to_action.g.dart';

@JsonSerializable()
class LineToAction extends PathAction {
  final double x;
  final double y;

  const LineToAction(this.x, this.y);

  factory LineToAction.fromJson(Map<String, dynamic> json) =>
      _$LineToActionFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$LineToActionToJson(this)..['type'] = SerializerType.LINE_TO_ACTION;

  @override
  bool operator ==(Object other) =>
      other is LineToAction && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);
}
