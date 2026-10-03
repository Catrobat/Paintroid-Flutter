import 'package:paintroid/core/backward_compatibility/kryo_class_registry.dart';
import 'package:paintroid/core/backward_compatibility/kryo_reader.dart';
import 'package:paintroid/core/backward_compatibility/models/legacy_serializable_action.dart';

class LegacySerializablePath {
  final List<LegacySerializableAction> actions;

  LegacySerializablePath(this.actions);

  factory LegacySerializablePath.deserialize(KryoReader reader) {
    final size = reader.readInt32();
    final List<LegacySerializableAction> actions = [];
    for (int i = 0; i < size; i++) {
      final action = KryoClassRegistry.readClassAndObject(reader);
      if (action is LegacySerializableAction) {
        actions.add(action);
      } else {
        throw FormatException(
          'Unexpected path action type in path list: $action',
        );
      }
    }
    return LegacySerializablePath(actions);
  }

  Map<String, dynamic> toJson() => {
    'actions': actions.map((a) => a.toJson()).toList(),
  };
}
