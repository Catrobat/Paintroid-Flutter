import 'package:flutter/foundation.dart';

abstract class VersionSerializer<FROM, TO> {
  final int version;

  static const v1 = 1;

  const VersionSerializer(this.version);

  TO serializeWithLatestVersion(FROM object);

  @nonVirtual
  FROM deserialize(TO data) {
    switch (version) {
      case v1:
        return deserializeV1(data);
      default:
        throw "Invalid version";
    }
  }

  @protected
  FROM deserializeV1(TO data) => deserializeWithLatestVersion(data);

  @protected
  FROM deserializeWithLatestVersion(TO data);
}
