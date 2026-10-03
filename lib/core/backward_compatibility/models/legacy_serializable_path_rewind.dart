import 'package:paintroid/core/backward_compatibility/kryo_reader.dart';
import 'package:paintroid/core/backward_compatibility/models/legacy_serializable_action.dart';

class LegacySerializablePathRewind implements LegacySerializableAction {
  LegacySerializablePathRewind();

  factory LegacySerializablePathRewind.deserialize(KryoReader reader) {
    return LegacySerializablePathRewind();
  }

  @override
  Map<String, dynamic> toJson() => {'type': 'Rewind'};
}
