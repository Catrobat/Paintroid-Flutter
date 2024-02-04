import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:io_library/io_library.dart';

class PathWithActionHistory extends Path {
  PathWithActionHistory();

  @PathActionConverter()
  final actions = <PathAction>[];

  @override
  void moveTo(double x, double y) {
    actions.add(MoveToAction(x, y));
    super.moveTo(x, y);
  }

  @override
  void lineTo(double x, double y) {
    actions.add(LineToAction(x, y));
    super.lineTo(x, y);
  }

  @override
  void close() {
    actions.add(const CloseAction());
    super.close();
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
