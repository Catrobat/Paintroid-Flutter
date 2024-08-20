import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:paintroid/core/commands/graphic_factory/graphic_factory.dart';
import 'package:paintroid/core/tools/tool.dart';

class SprayCanTool extends Tool {
  final GraphicFactory graphicFactory;
  final Random _random = Random();
  Timer? _sprayTimer;
  static const int _sprayInterval = 50;
  static const int _dotsPerSpray = 10;
  static const double _radius = 500.0;

  SprayCanTool({
    required super.commandFactory,
    required super.commandManager,
    required this.graphicFactory,
    required super.type,
    super.hasAddFunctionality = false,
    super.hasFinalizeFunctionality = false,
  });

  @override
  void onDown(Offset point, Paint paint) {
    _startSpraying(point, paint);
  }

  @override
  void onDrag(Offset point, Paint paint) {
    _startSpraying(point, paint);
  }

  @override
  void onUp(Offset point, Paint paint) {
    _stopSpraying();
  }

  @override
  void onCancel() {
    _stopSpraying();
  }

  void _startSpraying(Offset point, Paint paint) {
    _stopSpraying();
    _sprayTimer = Timer.periodic(
      const Duration(milliseconds: _sprayInterval),
      (_) => _spray(point, paint),
    );
  }

  void _stopSpraying() {
    _sprayTimer?.cancel();
  }

  void _spray(Offset center, Paint paint) {
    for (int i = 0; i < _dotsPerSpray; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final distance = _random.nextDouble() * _radius;

      final dx = center.dx + cos(angle) * distance;
      final dy = center.dy + sin(angle) * distance;
      final offset = Offset(dx, dy);

      _addDot(offset, paint);
    }
  }

  void _addDot(Offset point, Paint paint) {
    final dotCommand = commandFactory.createDotCommand(point, paint);
    commandManager.addGraphicCommand(dotCommand);
    if (_sprayTimer?.isActive == false) {
      commandManager.clearRedoStack();
    }
  }

  @override
  void onCheckmark(Paint paint) {}

  @override
  void onPlus() {}

  @override
  void onRedo() {}

  @override
  void onUndo() {}
}
