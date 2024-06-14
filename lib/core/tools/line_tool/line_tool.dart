// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:paintroid/core/commands/command_implementation/graphic/line_command.dart';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/commands/path_with_action_history.dart';
import 'package:paintroid/core/tools/line_tool/vertex.dart';
import 'package:paintroid/core/tools/line_tool/vertex_stack.dart';
import 'package:paintroid/core/tools/tool.dart';

class LineTool extends Tool with EquatableMixin {
  LineTool({
    required super.paint,
    required super.commandFactory,
    required super.commandManager,
    required this.graphicFactory,
    required this.drawingSurfaceSize,
    required super.type,
  });

  final GraphicFactory graphicFactory;
  final Size drawingSurfaceSize;

  VertexStack vertexStack = VertexStack();

  Vertex? movingVertex;
  Vertex? predecessorVertex;
  Vertex? successorVertex;

  LineCommand? ingoingGhostPathCommand;
  LineCommand? outgoingGhostPathCommand;

  bool addNewPath = false;

  @override
  List<Object?> get props => [commandManager, commandFactory, graphicFactory];

  @override
  void onDown(Offset point) {
    if (vertexWasClicked(point)) {
      return;
    }

    if (vertexStack.isEmpty) {
      _createSourceAndDestinationCommandAndVertices(point);
      return;
    }

    if (addNewPath) {
      _createDestinationCommandAndVertex(point);
      addNewPath = false;
      return;
    }
  }

  @override
  void onDrag(Offset point) {
    _setGhostPaths(point);
  }

  @override
  void onUp(Offset point) {
    _updateMovingVertices(point);
  }

  @override
  void onCancel() {
    reset();
  }

  void _setGhostPaths(Offset point) {
    if (movingVertex == null) return;

    point = getMovingVertexCenter(point);
    movingVertex?.updateVertexCenter(point);

    if (movingVertex?.ingoingPathCommand != null) {
      _updateGhostPath(
        movingVertex?.ingoingPathCommand,
        predecessorVertex?.vertexCenter,
        point,
        (path) => ingoingGhostPathCommand = path,
      );
    }

    if (movingVertex?.outgoingPathCommand != null) {
      _updateGhostPath(
        movingVertex?.outgoingPathCommand,
        point,
        successorVertex?.vertexCenter,
        (path) => outgoingGhostPathCommand = path,
      );
    }
  }

  void _updateGhostPath(
    LineCommand? pathCommand,
    Offset? ghostStartPoint,
    Offset? ghostEndPoint,
    Function(LineCommand) setGhostPath,
  ) {
    if (pathCommand == null ||
        ghostStartPoint == null ||
        ghostEndPoint == null) {
      return;
    }

    Paint paint = _copy(pathCommand.paint);
    paint.color = paint.color.withAlpha(Vertex.PAINT_ALPHA);
    setGhostPath(_createLineCommand(paint, ghostStartPoint, ghostEndPoint));
  }

  void _updateMovingVertices(Offset point) {
    if (movingVertex == null) return;

    point = getMovingVertexCenter(point);
    movingVertex?.updateVertexCenter(point);

    if (movingVertex?.ingoingPathCommand != null) {
      _updatePath(
        movingVertex?.ingoingPathCommand,
        predecessorVertex?.vertexCenter,
        point,
      );
    }

    if (movingVertex?.outgoingPathCommand != null) {
      _updatePath(
        movingVertex?.outgoingPathCommand,
        point,
        successorVertex?.vertexCenter,
      );
    }
    ingoingGhostPathCommand = null;
    outgoingGhostPathCommand = null;
  }

  void _updatePath(
    LineCommand? pathCommand,
    Offset? newStartPoint,
    Offset? newEndPoint,
  ) {
    if (pathCommand == null || newStartPoint == null || newEndPoint == null) {
      return;
    }
    updateLineCommand(pathCommand, newStartPoint, newEndPoint);
  }

  void onPlus() {
    addNewPath = true;
  }

  void onCheckMark() {
    reset();
  }

  void reset() {
    vertexStack.clear();
    predecessorVertex = null;
    movingVertex = null;
    successorVertex = null;
    ingoingGhostPathCommand = null;
    outgoingGhostPathCommand = null;
  }

  PathWithActionHistory _createPath(Offset startPoint, Offset endPoint) {
    var pathToDraw = graphicFactory.createPathWithActionHistory()
      ..moveTo(startPoint.dx, startPoint.dy)
      ..lineTo(endPoint.dx, endPoint.dy);
    return pathToDraw;
  }

  void _createSourceAndDestinationCommandAndVertices(Offset point) {
    final command = _createLineCommand(_copy(paint), point, point);
    commandManager.addGraphicCommand(command);
    command.setAsSourcePath();
    _createSourceAndDestinationVertices(point, point, command);
  }

  void _createSourceAndDestinationVertices(
      Offset startPoint, Offset endPoint, LineCommand command) {
    predecessorVertex = _createAndAddVertex(startPoint, command, null);
    movingVertex = _createAndAddVertex(endPoint, null, command);
  }

  void _createDestinationCommandAndVertex(Offset point) {
    final startPoint = vertexStack.last.vertexCenter;
    final command = _createLineCommand(_copy(paint), startPoint, startPoint);
    commandManager.addGraphicCommand(command);
    _createDestinationVertex(startPoint, command);
  }

  void _createDestinationVertex(Offset endPoint, LineCommand command) {
    vertexStack.last.setOutgoingPath(command);
    _createAndAddVertex(endPoint, null, command);
    _setLastMovingAndPredecessorVertex();
  }

  _copy(Paint paint) {
    return graphicFactory.copyPaint(paint);
  }

  LineCommand _createLineCommand(
      Paint paint, Offset startPoint, Offset endPoint) {
    final path = _createPath(startPoint, endPoint);
    final command =
        commandFactory.createLineCommand(path, paint, startPoint, endPoint);
    return command;
  }

  Vertex _createAndAddVertex(Offset vertexCenter,
      LineCommand? outgoingPathCommand, LineCommand? ingoingPathCommand) {
    Vertex vertex = Vertex(
        vertexCenter: vertexCenter,
        outgoingPathCommand: outgoingPathCommand,
        ingoingPathCommand: ingoingPathCommand);
    vertexStack.add(vertex);
    return vertex;
  }

  void _setLastMovingAndPredecessorVertex() {
    if (vertexStack.isEmpty) return;
    predecessorVertex = vertexStack.getPredecessor(vertexStack.last);
    movingVertex = vertexStack.last;
  }

  void updateLineCommand(LineCommand? command, newStartPoint, newEndPoint) {
    var path = _createPath(newStartPoint, newEndPoint);
    command?.updatePath(path);
  }

  void updateStrokeWidth(double newValue) {
    if (vertexStack.isEmpty) return;
    vertexStack.last.ingoingPathCommand?.paint.strokeWidth = newValue;
  }

  bool vertexWasClicked(Offset point) {
    if (vertexStack.isEmpty) return false;
    for (var vertex in vertexStack) {
      if (vertex.wasClicked(point)) {
        movingVertex = vertex;
        predecessorVertex = vertexStack.getPredecessor(vertex);
        successorVertex = vertexStack.getSuccessor(vertex);
        return true;
      }
    }
    return false;
  }

  Offset getMovingVertexCenter(Offset movingCoordinate) {
    var insidePoint =
        predecessorVertex?.vertexCenter ?? successorVertex?.vertexCenter;
    var outsidePoint = movingCoordinate;
    return calculateMovingVertexCenter(insidePoint, outsidePoint);
  }

  Offset calculateMovingVertexCenter(Offset? insidePoint, Offset outsidePoint) {
    if (insidePoint == null) return outsidePoint;

    var slope =
        (outsidePoint.dy - insidePoint.dy) / (outsidePoint.dx - insidePoint.dx);
    var yIntercept = insidePoint.dy - slope * insidePoint.dx;
    var surfaceHeight = drawingSurfaceSize.height;
    var surfaceWidth = drawingSurfaceSize.width;

    if (outsidePoint.dy < 0) {
      var x = -yIntercept / slope;
      if (x >= 0.0 && x <= surfaceWidth) {
        return Offset(x, 0.0);
      }
    }

    if (outsidePoint.dy > surfaceHeight) {
      var x = (surfaceHeight - yIntercept) / slope;
      if (x >= 0.0 && x <= surfaceWidth) {
        return Offset(x, surfaceHeight);
      }
    }

    if (outsidePoint.dx < 0 &&
        yIntercept >= 0.0 &&
        yIntercept <= surfaceHeight) {
      return Offset(0.0, yIntercept);
    }

    if (outsidePoint.dx > surfaceWidth) {
      var y = slope * surfaceWidth + yIntercept;
      if (y >= 0.0 && y <= surfaceHeight) {
        return Offset(surfaceWidth, y);
      }
    }

    return outsidePoint;
  }
}
