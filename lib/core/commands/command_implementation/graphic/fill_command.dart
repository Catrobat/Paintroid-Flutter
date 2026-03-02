// ignore_for_file: must_be_immutable

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:paintroid/core/commands/command_implementation/graphic/graphic_command.dart';
import 'package:paintroid/core/json_serialization/converter/paint_converter.dart';
import 'package:paintroid/core/json_serialization/converter/uint8list_base64_converter.dart';
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';
import 'package:paintroid/core/json_serialization/versioning/version_strategy.dart';

class FillCommand extends GraphicCommand {
  final Uint8List imageData;
  final int version;
  final String type;

  ui.Image? _runtimeImage;

  FillCommand(
    super.paint,
    this.imageData, {
    int? version,
    this.type = SerializerType.FILL_COMMAND,
  }) : version =
            version ?? VersionStrategyManager.strategy.getFillCommandVersion();

  @override
  Future<void> prepareForRuntime() async {
    if (_runtimeImage != null || imageData.isEmpty) {
      return;
    }
    final buffer = await ui.ImmutableBuffer.fromUint8List(imageData);
    final descriptor = await ui.ImageDescriptor.encoded(buffer);
    final codec = await descriptor.instantiateCodec();
    final frameInfo = await codec.getNextFrame();
    _runtimeImage = frameInfo.image;
  }

  @override
  void call(ui.Canvas canvas) {
    if (_runtimeImage == null) {
      return;
    }
    canvas.drawImage(_runtimeImage!, ui.Offset.zero, ui.Paint());
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'paint': const PaintConverter().toJson(paint),
      'imageData': const Uint8ListBase64Converter().toJson(imageData),
      'version': version,
      'type': type,
    };
  }

  factory FillCommand.fromJson(Map<String, dynamic> json) {
    return FillCommand(
      const PaintConverter().fromJson(json['paint'] as Map<String, dynamic>),
      const Uint8ListBase64Converter().fromJson(json['imageData'] as String),
      version: json['version'] as int? ?? Version.v1,
      type: json['type'] as String? ?? SerializerType.FILL_COMMAND,
    );
  }

  @override
  List<Object?> get props => [paint, imageData, version, type];
}
