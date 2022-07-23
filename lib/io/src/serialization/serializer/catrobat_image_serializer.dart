import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;
import 'package:paintroid/command/command.dart' show Command, DrawPathCommand;
import 'package:paintroid/io/io.dart' show CatrobatImage;
import 'package:paintroid/io/serialization.dart';

class CatrobatImageSerializer extends ProtoSerializerWithVersioning<
    CatrobatImage, SerializableCatrobatImage> {
  final DrawPathCommandSerializer _drawPathCommandSerializer;

  const CatrobatImageSerializer(super.version, this._drawPathCommandSerializer);

  static final provider = Provider.family(
    (ref, int ver) => CatrobatImageSerializer(
      ver,
      ref.watch(DrawPathCommandSerializer.provider(ver)),
    ),
  );

  @override
  SerializableCatrobatImage serializeWithLatestVersion(CatrobatImage object) {
    return SerializableCatrobatImage(
      magicValue: CatrobatImage.magicValue,
      version: CatrobatImage.latestVersion,
      loadedImage: object.loadedImage,
      commands: object.commands.map((command) {
        if (command is DrawPathCommand) {
          return Any.pack(
            _drawPathCommandSerializer.serializeWithLatestVersion(command),
            typeUrlPrefix: ProtoSerializerWithVersioning.urlPrefix,
          );
        } else {
          throw "Invalid command type";
        }
      }),
    );
  }

  @override
  CatrobatImage deserializeWithLatestVersion(SerializableCatrobatImage data) {
    final commands = <Command>[];
    for (final cmd in data.commands) {
      if (cmd.canUnpackInto(SerializableDrawPathCommand.getDefault())) {
        final unpacked = cmd.unpackInto(SerializableDrawPathCommand());
        commands.add(_drawPathCommandSerializer.deserialize(unpacked));
      } else {
        throw "Invalid command type";
      }
    }
    final loadedImage =
        data.loadedImage.isEmpty ? null : Uint8List.fromList(data.loadedImage);
    return CatrobatImage(commands, loadedImage, version: data.version);
  }

  @override
  final fromBytesToSerializable = SerializableCatrobatImage.fromBuffer;
}
