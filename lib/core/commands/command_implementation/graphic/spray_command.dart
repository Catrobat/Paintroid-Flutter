import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/graphic_command.dart';
import 'package:paintroid/core/json_serialization/converter/offset_converter.dart';
import 'package:paintroid/core/json_serialization/converter/paint_converter.dart';
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';
import 'package:paintroid/core/json_serialization/versioning/version_strategy.dart';

part 'spray_command.g.dart';

@JsonSerializable()
class SprayCommand extends GraphicCommand {
  final String type;
  final int version;

  @OffsetConverter()
  List<Offset> points;

  SprayCommand(
    this.points,
    super.paint, {
    this.type = SerializerType.SPRAY_COMMAND,
    int? version,
  }) : version =
            version ?? VersionStrategyManager.strategy.getSprayCommandVersion();

  @override
  void call(Canvas canvas) {
    canvas.drawPoints(PointMode.points, points, paint);
  }

  @override
  List<Object?> get props => [paint, points];

  @override
  Map<String, dynamic> toJson() => _$SprayCommandToJson(this);

  factory SprayCommand.fromJson(Map<String, dynamic> json) {
    int version = json['version'] as int;

    switch (version) {
      case Version.v1:
        return _$SprayCommandFromJson(json);
      default:
        return _$SprayCommandFromJson(json);
    }
  }
}
