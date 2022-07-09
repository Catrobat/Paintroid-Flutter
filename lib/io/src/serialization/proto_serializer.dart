import 'serializer.dart';

abstract class ProtoSerializer<T, S> implements Serializer<T> {
  T deserializeFromProto(S serializable);

  S convertToProtoSerializable(T object);
}
