import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;
import 'package:paintroid/core/graphic_factory.dart';
import 'package:paintroid/io/serialization.dart';

class PaintSerializer
    extends ProtoSerializerWithVersioning<Paint, SerializablePaint> {
  final GraphicFactory _graphicFactory;

  const PaintSerializer(super.version, this._graphicFactory);

  static final provider = Provider.family(
    (ref, int ver) => PaintSerializer(ver, ref.watch(GraphicFactory.provider)),
  );

  @override
  final fromBytesToSerializable = SerializablePaint.fromBuffer;

  @override
  Future<Paint> deserializeWithLatestVersion(SerializablePaint data) async {
    final paint = _graphicFactory.createPaint()
      ..color = Color(data.color)
      ..strokeWidth = data.strokeWidth;
    switch (data.cap) {
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
    switch (data.style) {
      case SerializablePaint_PaintingStyle.FILL:
        paint.style = PaintingStyle.fill;
        break;
      case SerializablePaint_PaintingStyle.STROKE:
        paint.style = PaintingStyle.stroke;
        break;
    }
    return paint;
  }

  @override
  Future<SerializablePaint> serializeWithLatestVersion(Paint object) async {
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
    switch (object.style) {
      case PaintingStyle.fill:
        serializable.style = SerializablePaint_PaintingStyle.FILL;
        break;
      case PaintingStyle.stroke:
        serializable.style = SerializablePaint_PaintingStyle.STROKE;
        break;
    }
    return serializable;
  }
}
