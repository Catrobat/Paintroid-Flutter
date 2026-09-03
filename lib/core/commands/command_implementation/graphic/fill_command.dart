// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/graphic_command.dart';
import 'package:paintroid/core/json_serialization/converter/offset_converter.dart';
import 'package:paintroid/core/json_serialization/converter/paint_converter.dart';
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';
import 'package:paintroid/core/json_serialization/versioning/version_strategy.dart';

part 'fill_command.g.dart';

@JsonSerializable()
class FillCommand extends GraphicCommand {
  final String type;
  final int version;

  @OffsetConverter()
  List<Offset> points;

  FillCommand(
    this.points,
    super.paint, {
    this.type = SerializerType.FILL_COMMAND,
    int? version,
  }) : version =
            version ?? VersionStrategyManager.strategy.getFillCommandVersion();

  @override
  void call(Canvas canvas) {
    for (int i = 0; i < points.length; i+=2) {
      canvas.drawLine(points[i], points[i+1], paint);
    }
  }

  @override
  List<Object?> get props => [paint, points];

  @override
  Map<String, dynamic> toJson() => _$FillCommandToJson(this);

  factory FillCommand.fromJson(Map<String, dynamic> json) {
    int version = json['version'] as int;

    switch (version) {
      case Version.v1:
        return _$FillCommandFromJson(json);
      default:
        return _$FillCommandFromJson(json);
    }
  }
}
