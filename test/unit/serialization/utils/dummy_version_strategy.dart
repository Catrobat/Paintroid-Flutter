import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';
import 'package:paintroid/core/json_serialization/versioning/version_strategy.dart';

class DummyVersionStrategy implements IVersionStrategy {
  final int pathCommandVersion;
  final int lineCommandVersion;
  final int catrobatImageVersion;
  final int rectangleShapeCommandVersion;
  final int circleShapeCommandVersion;

  DummyVersionStrategy({
    this.pathCommandVersion = SerializerVersion.PATH_COMMAND_VERSION,
    this.catrobatImageVersion = SerializerVersion.CATROBAT_IMAGE_VERSION,
    this.lineCommandVersion = SerializerVersion.LINE_COMMAND_VERSION,
    this.rectangleShapeCommandVersion = SerializerVersion.RECTANGLE_SHAPE_COMMAND_VERSION,
    this.circleShapeCommandVersion = SerializerVersion.CIRCLE_SHAPE_COMMAND_VERSION,
  });

  @override
  int getCatrobatImageVersion() => catrobatImageVersion;

  @override
  int getPathCommandVersion() => pathCommandVersion;

  @override
  int getLineCommandVersion() => lineCommandVersion;
  
  @override
  int getRectangleShapeCommandVersion() => rectangleShapeCommandVersion;

  @override
  int getCircleShapeCommandVersion() => circleShapeCommandVersion;
}
