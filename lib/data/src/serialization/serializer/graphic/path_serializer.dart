import 'dart:typed_data';
import 'dart:ui';

import 'package:paintroid/core/graphic_factory.dart';
import 'package:paintroid/core/path_with_action_history.dart';
import 'package:paintroid/data/serializable.dart';

class PathSerializer
    implements ProtoSerializer<PathWithActionHistory, SerializablePath> {
  final GraphicFactory graphicFactory;

  const PathSerializer(this.graphicFactory);

  @override
  PathWithActionHistory deserialize(Uint8List binary) {
    final serializablePath = SerializablePath.fromBuffer(binary);
    return deserializeFromProto(serializablePath);
  }

  @override
  PathWithActionHistory deserializeFromProto(SerializablePath serializable) {
    final path = graphicFactory.createPathWithActionHistory();
    switch (serializable.fillType) {
      case SerializablePath_FillType.EVEN_ODD:
        path.fillType = PathFillType.evenOdd;
        break;
      case SerializablePath_FillType.NON_ZERO:
        path.fillType = PathFillType.nonZero;
        break;
    }
    for (final action in serializable.actions) {
      if (action.hasMoveTo()) {
        path.moveTo(action.moveTo.x, action.moveTo.y);
      } else if (action.hasLineTo()) {
        path.lineTo(action.lineTo.x, action.lineTo.y);
      } else if (action.hasClose()) {
        path.close();
      }
    }
    return path;
  }

  @override
  Uint8List serialize(PathWithActionHistory object) =>
      convertToProtoSerializable(object).writeToBuffer();

  @override
  SerializablePath convertToProtoSerializable(PathWithActionHistory object) {
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
        final moveTo = SerializablePath_Action_MoveTo(x: action.x, y: action.y);
        serializableAction = SerializablePath_Action(moveTo: moveTo);
      } else if (action is LineToAction) {
        final lineTo = SerializablePath_Action_LineTo(x: action.x, y: action.y);
        serializableAction = SerializablePath_Action(lineTo: lineTo);
      } else if (action is CloseAction) {
        final close = SerializablePath_Action_Close();
        serializableAction = SerializablePath_Action(close: close);
      }
      serializablePath.actions.add(serializableAction);
    }
    return serializablePath;
  }
}
