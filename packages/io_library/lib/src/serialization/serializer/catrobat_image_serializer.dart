import 'dart:typed_data';
import 'dart:ui';

import 'package:command/command.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;
import 'package:io_library/io_library.dart';
import 'package:io_library/serialization.dart';

class CatrobatImageSerializer extends ProtoSerializerWithVersioning<
    CatrobatImage, SerializableCatrobatImage> {
  final DrawPathCommandSerializer _drawPathCommandSerializer;
  final IImageService _imageService;

  const CatrobatImageSerializer(
      super.version, this._imageService, this._drawPathCommandSerializer);

  static final provider = Provider.family(
    (ref, int ver) => CatrobatImageSerializer(
      ver,
      ref.watch(IImageService.provider),
      ref.watch(DrawPathCommandSerializer.provider(ver)),
    ),
  );

  @override
  Future<SerializableCatrobatImage> serializeWithLatestVersion(
      CatrobatImage object) async {
    Uint8List? backgroundImageData;
    if (object.backgroundImage != null) {
      final result = await _imageService.exportAsPng(object.backgroundImage!);
      backgroundImageData =
          result.unwrapOrElse((failure) => throw failure.message);
    }
    return SerializableCatrobatImage()
      ..magicValue = CatrobatImage.magicValue
      ..version = CatrobatImage.latestVersion
      ..width = object.width
      ..height = object.height
      ..backgroundImage =
          (backgroundImageData != null) ? backgroundImageData : Uint8List(0)
      ..commands.addAll(await Future.wait(object.commands.map((command) async {
        if (command is DrawPathCommand) {
          return Any.pack(
            await _drawPathCommandSerializer
                .serializeWithLatestVersion(command),
            typeUrlPrefix: ProtoSerializerWithVersioning.urlPrefix,
          );
        } else {
          throw 'Invalid command type';
        }
      })));
  }

  @override
  Future<CatrobatImage> deserializeWithLatestVersion(
      SerializableCatrobatImage data) async {
    final commands = <Command>[];
    for (final cmd in data.commands) {
      if (cmd.canUnpackInto(SerializableDrawPathCommand.getDefault())) {
        final unpacked = cmd.unpackInto(SerializableDrawPathCommand());
        commands.add(await _drawPathCommandSerializer.deserialize(unpacked));
      } else {
        throw 'Invalid command type';
      }
    }
    Image? image;
    if (data.hasBackgroundImage()) {
      final result =
          await _imageService.import(Uint8List.fromList(data.backgroundImage));
      image = result.unwrapOrElse((failure) => throw failure.message);
    }
    return CatrobatImage(commands, data.width, data.height, image,
        version: data.version);
  }

  @override
  final fromBytesToSerializable = SerializableCatrobatImage.fromBuffer;
}
