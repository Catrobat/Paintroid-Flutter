import 'package:paintroid/core/backward_compatibility/kryo_reader.dart';
import 'package:paintroid/core/backward_compatibility/models/legacy_serializable_action.dart';

class LegacySerializablePathMove implements LegacySerializableAction {
  final double x;
  final double y;

  LegacySerializablePathMove(this.x, this.y);

  factory LegacySerializablePathMove.deserialize(KryoReader reader) {
    final x = reader.readFloat();
    final y = reader.readFloat();
    return LegacySerializablePathMove(x, y);
  }

  @override
  Map<String, dynamic> toJson() => {'type': 'Move', 'x': x, 'y': y};
}
