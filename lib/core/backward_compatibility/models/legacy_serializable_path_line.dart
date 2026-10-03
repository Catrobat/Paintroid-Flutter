import 'package:paintroid/core/backward_compatibility/kryo_reader.dart';
import 'package:paintroid/core/backward_compatibility/models/legacy_serializable_action.dart';

class LegacySerializablePathLine implements LegacySerializableAction {
  final double x;
  final double y;

  LegacySerializablePathLine(this.x, this.y);

  factory LegacySerializablePathLine.deserialize(KryoReader reader) {
    final x = reader.readFloat();
    final y = reader.readFloat();
    return LegacySerializablePathLine(x, y);
  }

  @override
  Map<String, dynamic> toJson() => {'type': 'Line', 'x': x, 'y': y};
}
