import 'dart:ui';

class PathWithActionHistory extends Path {
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
}

abstract class PathAction {
  const PathAction();
}

class MoveToAction extends PathAction {
  final double x;
  final double y;

  const MoveToAction(this.x, this.y);
}

class LineToAction extends PathAction {
  final double x;
  final double y;

  const LineToAction(this.x, this.y);
}

class CloseAction extends PathAction {
  const CloseAction();
}