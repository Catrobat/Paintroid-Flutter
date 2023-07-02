import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/graphic_factory.dart';
import 'package:paintroid/core/loggable_mixin.dart';
import 'package:paintroid/core/path_with_action_history.dart';
import 'package:paintroid/io/serialization.dart';

class PathSerializer extends ProtoSerializerWithVersioning<
    PathWithActionHistory, SerializablePath> with LoggableMixin {
  final GraphicFactory _graphicFactory;

  PathSerializer(super.version, this._graphicFactory);

  static final provider = Provider.family(
    (ref, int ver) => PathSerializer(ver, ref.watch(GraphicFactory.provider)),
  );

  @override
  Future<PathWithActionHistory> deserializeWithLatestVersion(
      SerializablePath data) async {
    final path = _graphicFactory.createPathWithActionHistory();
    switch (data.fillType) {
      case SerializablePath_FillType.EVEN_ODD:
        path.fillType = PathFillType.evenOdd;
        break;
      case SerializablePath_FillType.NON_ZERO:
        path.fillType = PathFillType.nonZero;
        break;
    }
    for (var i = 0; i < data.actions.length; i++) {
      final action = data.actions[i];
      if (action.hasMoveTo()) {
        path.moveTo(action.moveTo.x, action.moveTo.y);
      } else if (action.hasLineTo()) {
        path.lineTo(action.lineTo.x, action.lineTo.y);
      } else if (action.hasClose()) {
        path.close();
      } else {
        logger.severe('No Path Action was set at index $i.');
      }
    }
    return path;
  }

  @override
  final fromBytesToSerializable = SerializablePath.fromBuffer;

  @override
  Future<SerializablePath> serializeWithLatestVersion(
      PathWithActionHistory object) async {
    final serializablePath = SerializablePath();
    switch (object.fillType) {
      case PathFillType.nonZero:
        serializablePath.fillType = SerializablePath_FillType.NON_ZERO;
        break;
      case PathFillType.evenOdd:
        serializablePath.fillType = SerializablePath_FillType.EVEN_ODD;
        break;
    }
    for (final action in object.actions) {
      late final SerializablePath_Action serializableAction;
      if (action is MoveToAction) {
        final moveTo = SerializablePath_Action_MoveTo()
          ..x = action.x
          ..y = action.y;
        serializableAction = SerializablePath_Action()..moveTo = moveTo;
      } else if (action is LineToAction) {
        final lineTo = SerializablePath_Action_LineTo()
          ..x = action.x
          ..y = action.y;
        serializableAction = SerializablePath_Action()..lineTo = lineTo;
      } else if (action is CloseAction) {
        final close = SerializablePath_Action_Close();
        serializableAction = SerializablePath_Action()..close = close;
      } else {
        logger.severe('Path Action serialization was not handled for $action');
      }
      serializablePath.actions.add(serializableAction);
    }
    return serializablePath;
  }
}
