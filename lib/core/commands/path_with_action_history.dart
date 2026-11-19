import 'dart:ui';

import 'package:collection/collection.dart';

import 'package:paintroid/core/json_serialization/converter/path_action_converter.dart';
import 'package:paintroid/core/json_serialization/converter/path_with_action_history_converter.dart';

class PathWithActionHistory {
  PathWithActionHistory();

  final path = Path();

  @PathActionConverter()
  final actions = <PathAction>[];

  void moveTo(double x, double y) {
    actions.add(MoveToAction(x, y));
    path.moveTo(x, y);
  }

  void lineTo(double x, double y) {
    actions.add(LineToAction(x, y));
    path.lineTo(x, y);
  }

  void close() {
    actions.add(const CloseAction());
    path.close();
  }

  void quadTo(double x1, double y1, double x2, double y2) {
    actions.add(QuadToAction(x1, y1, x2, y2));
    path.quadraticBezierTo(x1, y1, x2, y2);
  }

  void cubicTo(
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
  ) {
    actions.add(CubicToAction(x1, y1, x2, y2, x3, y3));
    path.cubicTo(x1, y1, x2, y2, x3, y3);
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

class QuadToAction extends PathAction {
  final double x1;
  final double y1;
  final double x2;
  final double y2;

  const QuadToAction(this.x1, this.y1, this.x2, this.y2);

  @override
  bool operator ==(Object other) {
    if (other is QuadToAction) {
      return x1 == other.x1 &&
          y1 == other.y1 &&
          x2 == other.x2 &&
          y2 == other.y2;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(x1, y1, x2, y2);
}

class CubicToAction extends PathAction {
  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final double x3;
  final double y3;

  const CubicToAction(this.x1, this.y1, this.x2, this.y2, this.x3, this.y3);

  @override
  bool operator ==(Object other) {
    if (other is CubicToAction) {
      return x1 == other.x1 &&
          y1 == other.y1 &&
          x2 == other.x2 &&
          y2 == other.y2 &&
          x3 == other.x3 &&
          y3 == other.y3;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(x1, y1, x2, y2, x3, y3);
}
