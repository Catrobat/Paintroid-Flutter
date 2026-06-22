import 'package:paintroid/core/backward_compatibility/kryo_reader.dart';

class LegacyFloatArray {
  final List<double> values;

  LegacyFloatArray(this.values);

  factory LegacyFloatArray.deserialize(KryoReader reader) {
    final size = reader.readInt32();
    final List<double> values = [];
    for (int i = 0; i < size; i++) {
      values.add(reader.readFloat());
    }
    return LegacyFloatArray(values);
  }
}
