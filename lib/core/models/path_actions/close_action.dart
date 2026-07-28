import 'package:json_annotation/json_annotation.dart';
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';
import 'package:paintroid/core/models/path_actions/path_action.dart';

part 'close_action.g.dart';

@JsonSerializable()
class CloseAction extends PathAction {
  const CloseAction();

  factory CloseAction.fromJson(Map<String, dynamic> json) => const CloseAction();

  @override
  Map<String, dynamic> toJson() => {'type': SerializerType.CLOSE_ACTION};

  @override
  bool operator ==(Object other) => other is CloseAction;

  @override
  int get hashCode => runtimeType.hashCode;
}
