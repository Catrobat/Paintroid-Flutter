class SerializerVersion {
  static const int PAINT_VERSION = Version.v1;
  static const int CATROBAT_IMAGE_VERSION = Version.v1;
  static const int PATH_COMMAND_VERSION = Version.v1;
  static const int LINE_COMMAND_VERSION = Version.v1;
  static const int SQUARE_SHAPE_COMMAND_VERSION = Version.v1;
  static const int CIRCLE_SHAPE_COMMAND_VERSION = Version.v1;
}

class Version {
  static const int v1 = 1;
  static const int v2 = 2;
  static const int v3 = 3;
}

class SerializerType {
  static const String PATH_COMMAND = 'PathCommand';
  static const String LINE_COMMAND = 'LineCommand';
  static const String MOVE_TO_ACTION = 'MoveToAction';
  static const String LINE_TO_ACTION = 'LineToAction';
  static const String CLOSE_ACTION = 'CloseAction';
  static const String SQUARE_SHAPE_COMMAND = 'SquareShapeCommand';
  static const String CIRCLE_SHAPE_COMMAND = 'CircleShapeCommand';
}
