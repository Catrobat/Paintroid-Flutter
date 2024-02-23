class SerializerVersion {
  static const int PAINT_VERSION = Version.v1;
  static const int CATROBAT_IMAGE_VERSION = Version.v1;
  static const int DRAW_PATH_COMMAND_VERSION = Version.v1;
}

class Version {
  static const int v1 = 1;
  static const int v2 = 2;
  static const int v3 = 3;
// ...
}

class SerializerType {
  static const String DRAW_PATH_COMMAND = 'DrawPathCommand';
  static const String MOVE_TO_ACTION = 'MoveToAction';
  static const String LINE_TO_ACTION = 'LineToAction';
  static const String CLOSE_ACTION = 'CloseAction';
}
