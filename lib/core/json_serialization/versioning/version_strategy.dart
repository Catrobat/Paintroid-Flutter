// Project imports:

// Project imports:
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';

abstract class IVersionStrategy {
  int getCatrobatImageVersion();
  int getDrawPathCommandVersion();
}

class ProductionVersionStrategy implements IVersionStrategy {
  @override
  int getCatrobatImageVersion() => SerializerVersion.CATROBAT_IMAGE_VERSION;

  @override
  int getDrawPathCommandVersion() =>
      SerializerVersion.DRAW_PATH_COMMAND_VERSION;
}

class VersionStrategyManager {
  static IVersionStrategy _strategy = ProductionVersionStrategy();

  static void setStrategy(IVersionStrategy strategy) {
    _strategy = strategy;
  }

  static IVersionStrategy get strategy => _strategy;
}
