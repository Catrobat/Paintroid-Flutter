import 'package:paintroid/core/backward_compatibility/kryo_reader.dart';
import 'package:paintroid/core/backward_compatibility/models/legacy_serializable_action.dart';

class LegacySerializablePathCube implements LegacySerializableAction {
  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final double x3;
  final double y3;

  LegacySerializablePathCube(
    this.x1,
    this.y1,
    this.x2,
    this.y2,
    this.x3,
    this.y3,
  );

  factory LegacySerializablePathCube.deserialize(KryoReader reader) {
    final x1 = reader.readFloat();
    final y1 = reader.readFloat();
    final x2 = reader.readFloat();
    final y2 = reader.readFloat();
    final x3 = reader.readFloat();
    final y3 = reader.readFloat();
    return LegacySerializablePathCube(x1, y1, x2, y2, x3, y3);
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': 'Cube',
    'x1': x1,
    'y1': y1,
    'x2': x2,
    'y2': y2,
    'x3': x3,
    'y3': y3,
  };
}
