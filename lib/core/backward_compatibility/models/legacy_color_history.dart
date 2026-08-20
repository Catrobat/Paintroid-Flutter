import 'package:paintroid/core/backward_compatibility/kryo_reader.dart';

class LegacyColorHistory {
  final List<int> colors;

  LegacyColorHistory(this.colors);

  factory LegacyColorHistory.deserialize(KryoReader reader) {
    final size = reader.readInt32();
    final List<int> colors = [];
    for (int i = 0; i < size; i++) {
      colors.add(reader.readInt32());
    }
    return LegacyColorHistory(colors);
  }

  Map<String, dynamic> toJson() => {'colors': colors};
}
