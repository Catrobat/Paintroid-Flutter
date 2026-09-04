import 'package:paintroid/core/backward_compatibility/kryo_class_registry.dart';
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

class LegacyRectF {
  final double left;
  final double top;
  final double right;
  final double bottom;

  LegacyRectF(this.left, this.top, this.right, this.bottom);

  factory LegacyRectF.deserialize(KryoReader reader) {
    final left = reader.readFloat();
    final top = reader.readFloat();
    final right = reader.readFloat();
    final bottom = reader.readFloat();
    return LegacyRectF(left, top, right, bottom);
  }

  Map<String, dynamic> toJson() => {
    'left': left,
    'top': top,
    'right': right,
    'bottom': bottom,
  };
}

class LegacyPaint {
  final int color;
  final double strokeWidth;
  final int strokeCap;
  final bool isAntiAlias;
  final int style;
  final int strokeJoin;
  final bool hadFilter;
  final int alpha;

  LegacyPaint({
    required this.color,
    required this.strokeWidth,
    required this.strokeCap,
    required this.isAntiAlias,
    required this.style,
    required this.strokeJoin,
    required this.hadFilter,
    required this.alpha,
  });

  factory LegacyPaint.deserialize(KryoReader reader) {
    final color = reader.readInt32();
    final strokeWidth = reader.readFloat();
    final strokeCap = reader.readInt32();
    final isAntiAlias = reader.readBoolean();
    final style = reader.readInt32();
    final strokeJoin = reader.readInt32();
    final hadFilter = reader.readBoolean();
    final alpha = reader.readInt32();

    return LegacyPaint(
      color: color,
      strokeWidth: strokeWidth,
      strokeCap: strokeCap,
      isAntiAlias: isAntiAlias,
      style: style,
      strokeJoin: strokeJoin,
      hadFilter: hadFilter,
      alpha: alpha,
    );
  }

  Map<String, dynamic> toJson() => {
    'color': color,
    'strokeWidth': strokeWidth,
    'strokeCap': strokeCap,
    'isAntiAlias': isAntiAlias,
    'style': style,
    'strokeJoin': strokeJoin,
    'hadFilter': hadFilter,
    'alpha': alpha,
  };
}

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

class LegacyFloatArray {
  final List<double> values;

  LegacyFloatArray(this.values);

  factory LegacyFloatArray.deserialize(KryoReader reader) {
    final size = reader.readInt32();
    final List<double> values = [];
    for (int i = 0; i < size; i++) {
      values.add(reader.readFloat());
    }
    return LegacyFloatArray(values);
  }
}

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

abstract class LegacySerializableAction {
  Map<String, dynamic> toJson();
}

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

class LegacySerializablePathRewind implements LegacySerializableAction {
  LegacySerializablePathRewind();

  factory LegacySerializablePathRewind.deserialize(KryoReader reader) {
    return LegacySerializablePathRewind();
  }

  @override
  Map<String, dynamic> toJson() => {'type': 'Rewind'};
}

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
