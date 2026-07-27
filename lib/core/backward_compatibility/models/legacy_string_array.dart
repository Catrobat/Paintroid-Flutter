import 'package:paintroid/core/backward_compatibility/kryo_reader.dart';

class LegacyStringArray {
  final List<String> values;

  LegacyStringArray(this.values);

  factory LegacyStringArray.deserialize(KryoReader reader) {
    final size = reader.readInt32();
    final List<String> values = [];
    for (int i = 0; i < size; i++) {
      final str = reader.readString();
      if (str != null) {
        values.add(str);
      }
    }
    return LegacyStringArray(values);
  }
}
