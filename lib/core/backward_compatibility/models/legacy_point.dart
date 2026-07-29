import 'package:paintroid/core/backward_compatibility/kryo_reader.dart';

class LegacyPoint {
  final int x;
  final int y;

  LegacyPoint(this.x, this.y);

  factory LegacyPoint.deserialize(KryoReader reader) {
    final x = reader.readInt32();
    final y = reader.readInt32();
    return LegacyPoint(x, y);
  }

  Map<String, dynamic> toJson() => {'x': x, 'y': y};
}
