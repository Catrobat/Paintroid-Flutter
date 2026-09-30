import 'package:paintroid/core/backward_compatibility/kryo_reader.dart';

class LegacyPointF {
  final double x;
  final double y;

  LegacyPointF(this.x, this.y);

  factory LegacyPointF.deserialize(KryoReader reader) {
    final x = reader.readFloat();
    final y = reader.readFloat();
    return LegacyPointF(x, y);
  }

  Map<String, dynamic> toJson() => {'x': x, 'y': y};
}
