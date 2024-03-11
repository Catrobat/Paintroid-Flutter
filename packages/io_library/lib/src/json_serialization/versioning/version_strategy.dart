import 'package:io_library/io_library.dart';

abstract class IVersionStrategy {
  int getCatrobatImageVersion();
  int getPathCommandVersion();
  int getLineCommandVersion();
}

class ProductionVersionStrategy implements IVersionStrategy {
  @override
  int getCatrobatImageVersion() => SerializerVersion.CATROBAT_IMAGE_VERSION;

  @override
  int getPathCommandVersion() => SerializerVersion.PATH_COMMAND_VERSION;

  @override
  int getLineCommandVersion() => SerializerVersion.LINE_COMMAND_VERSION;
}

class VersionStrategyManager {
  static IVersionStrategy _strategy = ProductionVersionStrategy();

  static void setStrategy(IVersionStrategy strategy) {
    _strategy = strategy;
  }

  static IVersionStrategy get strategy => _strategy;
}
