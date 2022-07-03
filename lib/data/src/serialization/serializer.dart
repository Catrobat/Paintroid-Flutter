import 'dart:typed_data';

abstract class Serializer<T> {
  Uint8List serialize(T object);

  T deserialize(Uint8List binary);
}
