import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/graphic_command.dart';
import 'package:paintroid/core/json_serialization/versioning/version_strategy.dart';

@JsonSerializable()
class ShapesCommand extends GraphicCommand {
  final String type;
  final int version;

  ShapesCommand(
    super.paint,
    this.type,
    int? version,
  ) : version =
            version ?? VersionStrategyManager.strategy.getLineCommandVersion();

  @override
  void call(Canvas canvas) {
    // TODO: implement call
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
