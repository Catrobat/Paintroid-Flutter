import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;
import 'package:paintroid/core/graphic_factory.dart';
import 'package:paintroid/core/graphic_factory_provider.dart';
import 'package:paintroid/io/serialization.dart';

class PaintSerializer
    extends ProtoSerializerWithVersioning<Paint, SerializablePaint> {
  final GraphicFactory _graphicFactory;

  static const _capMap = {
    SerializablePaint_StrokeCap.STROKE_CAP_BUTT: StrokeCap.butt,
    SerializablePaint_StrokeCap.STROKE_CAP_ROUND: StrokeCap.round,
    SerializablePaint_StrokeCap.STROKE_CAP_SQUARE: StrokeCap.square,
  };

  static const _styleMap = {
    SerializablePaint_PaintingStyle.PAINTING_STYLE_FILL: PaintingStyle.fill,
    SerializablePaint_PaintingStyle.PAINTING_STYLE_STROKE: PaintingStyle.stroke,
  };

  static const _blendModeMap = {
    SerializablePaint_BlendMode.BLEND_MODE_SCR_OVER: BlendMode.srcOver,
    SerializablePaint_BlendMode.BLEND_MODE_CLEAR: BlendMode.clear,
  };

  static const _strokeJoinMap = {
    SerializablePaint_StrokeJoin.STROKE_JOIN_MITER: StrokeJoin.miter,
    SerializablePaint_StrokeJoin.STROKE_JOIN_ROUND: StrokeJoin.round,
    SerializablePaint_StrokeJoin.STROKE_JOIN_BEVEL: StrokeJoin.bevel,
  };

  const PaintSerializer(super.version, this._graphicFactory);

  static final provider = Provider.family(
    (ref, int ver) => PaintSerializer(ver, ref.watch(graphicFactoryProvider)),
  );

  @override
  final fromBytesToSerializable = SerializablePaint.fromBuffer;

  @override
  Future<Paint> deserializeWithLatestVersion(SerializablePaint data) async {
    return _graphicFactory.createPaint()
      ..color = Color(data.color)
      ..strokeWidth = data.strokeWidth
      ..strokeCap = _capMap[data.cap] ?? StrokeCap.butt
      ..style = _styleMap[data.style] ?? PaintingStyle.fill
      ..blendMode = _blendModeMap[data.blendMode] ?? BlendMode.srcOver
      ..strokeJoin = _strokeJoinMap[data.strokeJoin] ?? StrokeJoin.miter;
  }

  @override
  Future<SerializablePaint> serializeWithLatestVersion(Paint object) async {
    final serializable = SerializablePaint()
      ..color = object.color.value
      ..strokeWidth = object.strokeWidth
      ..cap = _capMap.entries.firstWhere((e) => e.value == object.strokeCap).key
      ..style = _styleMap.entries.firstWhere((e) => e.value == object.style).key
      ..blendMode = _blendModeMap.entries
          .firstWhere((e) => e.value == object.blendMode)
          .key
      ..strokeJoin = _strokeJoinMap.entries
          .firstWhere((e) => e.value == object.strokeJoin)
          .key;
    return serializable;
  }
}
