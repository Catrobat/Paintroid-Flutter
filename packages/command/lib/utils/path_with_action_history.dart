import 'dart:typed_data';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:io_library/io_library.dart';

class PathWithActionHistory implements Path {
  PathWithActionHistory();

  @PathActionConverter()
  final actions = <PathAction>[];

  final _path = Path();

  @override
  void moveTo(double x, double y) {
    actions.add(MoveToAction(x, y));
    _path.moveTo(x, y);
  }

  @override
  void lineTo(double x, double y) {
    actions.add(LineToAction(x, y));
    _path.lineTo(x, y);
  }

  @override
  void close() {
    actions.add(const CloseAction());
    _path.close();
  }

  Map<String, dynamic> toJson() {
    return const PathWithActionHistoryConverter().toJson(this);
  }

  factory PathWithActionHistory.fromJson(Map<String, dynamic> json) {
    return const PathWithActionHistoryConverter().fromJson(json);
  }

  @override
  bool operator ==(Object other) {
    if (other is PathWithActionHistory) {
      return const ListEquality<PathAction>().equals(actions, other.actions);
    }
    return false;
  }

  @override
  int get hashCode => const ListEquality<PathAction>().hash(actions);

  @override
  PathFillType get fillType => _path.fillType;

  @override
  set fillType(PathFillType value) => _path.fillType = value;

  @override
  void addArc(Rect oval, double startAngle, double sweepAngle) {
    // TODO: implement addArc
  }

  @override
  void addOval(Rect oval) {
    // TODO: implement addOval
  }

  @override
  void addPath(Path path, Offset offset, {Float64List? matrix4}) {
    // TODO: implement addPath
  }

  @override
  void addPolygon(List<Offset> points, bool close) {
    // TODO: implement addPolygon
  }

  @override
  void addRRect(RRect rrect) {
    // TODO: implement addRRect
  }

  @override
  void addRect(Rect rect) {
    // TODO: implement addRect
  }

  @override
  void arcTo(
      Rect rect, double startAngle, double sweepAngle, bool forceMoveTo) {
    // TODO: implement arcTo
  }

  @override
  void arcToPoint(Offset arcEnd,
      {Radius radius = Radius.zero,
      double rotation = 0.0,
      bool largeArc = false,
      bool clockwise = true}) {
    // TODO: implement arcToPoint
  }

  @override
  PathMetrics computeMetrics({bool forceClosed = false}) {
    // TODO: implement computeMetrics
    throw UnimplementedError();
  }

  @override
  void conicTo(double x1, double y1, double x2, double y2, double w) {
    // TODO: implement conicTo
  }

  @override
  bool contains(Offset point) {
    // TODO: implement contains
    throw UnimplementedError();
  }

  @override
  void cubicTo(
      double x1, double y1, double x2, double y2, double x3, double y3) {
    // TODO: implement cubicTo
  }

  @override
  void extendWithPath(Path path, Offset offset, {Float64List? matrix4}) {
    // TODO: implement extendWithPath
  }

  @override
  Rect getBounds() {
    // TODO: implement getBounds
    throw UnimplementedError();
  }

  @override
  void quadraticBezierTo(double x1, double y1, double x2, double y2) {
    // TODO: implement quadraticBezierTo
  }

  @override
  void relativeArcToPoint(Offset arcEndDelta,
      {Radius radius = Radius.zero,
      double rotation = 0.0,
      bool largeArc = false,
      bool clockwise = true}) {
    // TODO: implement relativeArcToPoint
  }

  @override
  void relativeConicTo(double x1, double y1, double x2, double y2, double w) {
    // TODO: implement relativeConicTo
  }

  @override
  void relativeCubicTo(
      double x1, double y1, double x2, double y2, double x3, double y3) {
    // TODO: implement relativeCubicTo
  }

  @override
  void relativeLineTo(double dx, double dy) {
    // TODO: implement relativeLineTo
  }

  @override
  void relativeMoveTo(double dx, double dy) {
    // TODO: implement relativeMoveTo
  }

  @override
  void relativeQuadraticBezierTo(double x1, double y1, double x2, double y2) {
    // TODO: implement relativeQuadraticBezierTo
  }

  @override
  void reset() {
    // TODO: implement reset
  }

  @override
  Path shift(Offset offset) {
    // TODO: implement shift
    throw UnimplementedError();
  }

  @override
  Path transform(Float64List matrix4) {
    // TODO: implement transform
    throw UnimplementedError();
  }
}

abstract class PathAction {
  const PathAction();
}

class MoveToAction extends PathAction {
  final double x;
  final double y;

  const MoveToAction(this.x, this.y);

  @override
  bool operator ==(Object other) {
    if (other is MoveToAction) {
      return x == other.x && y == other.y;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(x, y);
}

class LineToAction extends PathAction {
  final double x;
  final double y;

  const LineToAction(this.x, this.y);

  @override
  bool operator ==(Object other) {
    if (other is LineToAction) {
      return x == other.x && y == other.y;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(x, y);
}

class CloseAction extends PathAction {
  const CloseAction();
}
