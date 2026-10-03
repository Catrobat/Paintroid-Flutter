import 'package:paintroid/core/backward_compatibility/kryo_reader.dart';

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
