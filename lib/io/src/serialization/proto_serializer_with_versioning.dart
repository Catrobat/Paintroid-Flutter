import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:protobuf/protobuf.dart' show GeneratedMessage;

import 'version_serializer.dart';

abstract class ProtoSerializerWithVersioning<T,
        SERIALIZABLE extends GeneratedMessage>
    extends VersionSerializer<T, SERIALIZABLE> {
  const ProtoSerializerWithVersioning(super.version);

  static const urlPrefix = "org.catrobat.paintroid";

  @protected
  SERIALIZABLE Function(Uint8List binary) get fromBytesToSerializable;

  @nonVirtual
  Future<T> fromBytes(Uint8List binary) =>
      deserialize(fromBytesToSerializable(binary));

  @nonVirtual
  Future<Uint8List> toBytes(T object) async =>
      (await serializeWithLatestVersion(object)).writeToBuffer();
}
