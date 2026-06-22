import 'package:paintroid/core/backward_compatibility/kryo_reader.dart';

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
