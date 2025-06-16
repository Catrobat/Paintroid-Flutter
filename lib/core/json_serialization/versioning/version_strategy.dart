import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';

abstract class IVersionStrategy {
  int getCatrobatImageVersion();

  int getPathCommandVersion();

  int getLineCommandVersion();

  int getSquareShapeCommandVersion();

  int getOvalShapeCommandVersion();

  int getStarShapeCommandVersion();

  int getHeartShapeCommandVersion();

  int getSprayCommandVersion();
}

class ProductionVersionStrategy implements IVersionStrategy {
  @override
  int getCatrobatImageVersion() => SerializerVersion.CATROBAT_IMAGE_VERSION;

  @override
  int getPathCommandVersion() => SerializerVersion.PATH_COMMAND_VERSION;

  @override
  int getLineCommandVersion() => SerializerVersion.LINE_COMMAND_VERSION;

  @override
  int getSquareShapeCommandVersion() =>
      SerializerVersion.SQUARE_SHAPE_COMMAND_VERSION;

  @override
  int getOvalShapeCommandVersion() =>
      SerializerVersion.OVAL_SHAPE_COMMAND_VERSION;

  @override
  int getStarShapeCommandVersion() =>
      SerializerVersion.STAR_SHAPE_COMMAND_VERSION;

  @override
  int getHeartShapeCommandVersion() =>
      SerializerVersion.HEART_SHAPE_COMMAND_VERSION;

  @override
  int getSprayCommandVersion() => SerializerVersion.SPRAY_COMMAND_VERSION;
}

class VersionStrategyManager {
  static IVersionStrategy _strategy = ProductionVersionStrategy();

  static void setStrategy(IVersionStrategy strategy) {
    _strategy = strategy;
  }

  static IVersionStrategy get strategy => _strategy;
}
