import 'dart:typed_data';
import 'dart:ui';

import 'package:paintroid/core/graphic_factory.dart';

import '../../proto/output/graphic/paint.pb.dart';
import '../../proto_serializer.dart';

class PaintSerializer implements ProtoSerializer<Paint, SerializablePaint> {
  final GraphicFactory graphicFactory;

  const PaintSerializer(this.graphicFactory);

  @override
  Paint deserialize(Uint8List binary) {
    final serializablePaint = SerializablePaint.fromBuffer(binary);
    return deserializeFromProto(serializablePaint);
  }

  @override
  Paint deserializeFromProto(SerializablePaint serializable) {
    final paint = graphicFactory.createPaint()
      ..color = Color(serializable.color)
      ..strokeWidth = serializable.strokeWidth;
    switch (serializable.cap) {
      case SerializablePaint_StrokeCap.BUTT:
        paint.strokeCap = StrokeCap.butt;
        break;
      case SerializablePaint_StrokeCap.ROUND:
        paint.strokeCap = StrokeCap.round;
        break;
      case SerializablePaint_StrokeCap.SQUARE:
        paint.strokeCap = StrokeCap.square;
        break;
    }
    return paint;
  }

  @override
  Uint8List serialize(Paint object) =>
      convertToProtoSerializable(object).writeToBuffer();

  @override
  SerializablePaint convertToProtoSerializable(Paint object) {
    final serializable = SerializablePaint()
      ..color = object.color.value
      ..strokeWidth = object.strokeWidth;
    switch (object.strokeCap) {
      case StrokeCap.butt:
        serializable.cap = SerializablePaint_StrokeCap.BUTT;
        break;
      case StrokeCap.round:
        serializable.cap = SerializablePaint_StrokeCap.ROUND;
        break;
      case StrokeCap.square:
        serializable.cap = SerializablePaint_StrokeCap.SQUARE;
        break;
    }
    return serializable;
  }
}
