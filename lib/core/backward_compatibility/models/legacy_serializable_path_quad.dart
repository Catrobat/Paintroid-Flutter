import 'package:paintroid/core/backward_compatibility/kryo_reader.dart';
import 'package:paintroid/core/backward_compatibility/models/legacy_serializable_action.dart';

class LegacySerializablePathQuad implements LegacySerializableAction {
  final double x1;
  final double y1;
  final double x2;
  final double y2;

  LegacySerializablePathQuad(this.x1, this.y1, this.x2, this.y2);

  factory LegacySerializablePathQuad.deserialize(KryoReader reader) {
    final x1 = reader.readFloat();
    final y1 = reader.readFloat();
    final x2 = reader.readFloat();
    final y2 = reader.readFloat();
    return LegacySerializablePathQuad(x1, y1, x2, y2);
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': 'Quad',
    'x1': x1,
    'y1': y1,
    'x2': x2,
    'y2': y2,
  };
}
