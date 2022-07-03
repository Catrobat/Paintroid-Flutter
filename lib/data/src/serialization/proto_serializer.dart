import 'package:paintroid/data/serializable.dart';

abstract class ProtoSerializer<T, S> extends Serializer<T> {
  T deserializeFromProto(S serializable);
  S convertToProtoSerializable(T object);
}
