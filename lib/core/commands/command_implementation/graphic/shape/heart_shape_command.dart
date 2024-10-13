import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paintroid/core/commands/command_implementation/graphic/shape/shape_command.dart';
import 'package:paintroid/core/json_serialization/converter/offset_converter.dart';
import 'package:paintroid/core/json_serialization/converter/paint_converter.dart';
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';
import 'package:paintroid/core/json_serialization/versioning/version_strategy.dart';

part 'heart_shape_command.g.dart';

@JsonSerializable()
class HeartShapeCommand extends ShapeCommand {
  final double width;
  final double height;
  final double angle;
  @OffsetConverter()
  final Offset center;

  final int version;
  final String type;

  HeartShapeCommand(
    super.paint,
    this.width,
    this.height,
    this.angle,
    this.center, {
    int? version,
    this.type = SerializerType.HEART_SHAPE_COMMAND,
  }) : version = version ??
            VersionStrategyManager.strategy.getHeartShapeCommandVersion();

  Path get path => _getHeartPath(angle);

  @override
  void call(Canvas canvas) => canvas.drawPath(path, paint);

  @override
  List<Object?> get props => [paint, width, height, center];

  @override
  Map<String, dynamic> toJson() => _$HeartShapeCommandToJson(this);

  factory HeartShapeCommand.fromJson(Map<String, dynamic> json) {
    int version = json['version'] as int;

    switch (version) {
      case Version.v1:
        return _$HeartShapeCommandFromJson(json);
      default:
        return _$HeartShapeCommandFromJson(json);
    }
  }

  Path _getHeartPath(double angle) {
    Path path = Path();
    final double w = width / 2;
    final double h = height / 2;
    const double rotationOffset = 3 * pi / 4;

    path.moveTo(0, -h * 0.25);

    path.cubicTo(
      -w,
      -h * 1.25,
      -w * 1.25,
      h * 0.25,
      0,
      h * 0.75,
    );

    path.cubicTo(
      w * 1.25,
      h * 0.25,
      w,
      -h * 1.25,
      0,
      -h * 0.25,
    );

    path.close();

    final Matrix4 rotationMatrix = Matrix4.identity()
      ..rotateZ(angle + rotationOffset);

    path = path.transform(rotationMatrix.storage);

    path = path.shift(center);

    return path;
  }
}
