import 'package:flutter/foundation.dart';

abstract class VersionSerializer<FROM, TO> {
  final int version;

  static const v1 = 1;

  const VersionSerializer(this.version);

  Future<TO> serializeWithLatestVersion(FROM object);

  @nonVirtual
  Future<FROM> deserialize(TO data) {
    switch (version) {
      case v1:
        return deserializeV1(data);
      default:
        throw "Invalid version";
    }
  }

  @protected
  Future<FROM> deserializeV1(TO data) => deserializeWithLatestVersion(data);

  @protected
  Future<FROM> deserializeWithLatestVersion(TO data);
}
