import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';
import 'package:paintroid/core/json_serialization/versioning/version_strategy.dart';

class DummyVersionStrategy implements IVersionStrategy {
  final int pathCommandVersion;
  final int lineCommandVersion;
  final int catrobatImageVersion;
  final int squareShapeCommandVersion;
  final int ellipseShapeCommandVersion;
  final int starShapeCommandVersion;
  final int heartShapeCommandVersion;
  final int sprayCommandVersion;
  final int textCommandVersion;

  DummyVersionStrategy({
    this.pathCommandVersion = SerializerVersion.PATH_COMMAND_VERSION,
    this.catrobatImageVersion = SerializerVersion.CATROBAT_IMAGE_VERSION,
    this.lineCommandVersion = SerializerVersion.LINE_COMMAND_VERSION,
    this.squareShapeCommandVersion =
        SerializerVersion.SQUARE_SHAPE_COMMAND_VERSION,
    this.ellipseShapeCommandVersion =
        SerializerVersion.ELLIPSE_SHAPE_COMMAND_VERSION,
    this.starShapeCommandVersion = SerializerVersion.STAR_SHAPE_COMMAND_VERSION,
    this.heartShapeCommandVersion =
        SerializerVersion.HEART_SHAPE_COMMAND_VERSION,
    this.sprayCommandVersion = SerializerVersion.SPRAY_COMMAND_VERSION,
    this.textCommandVersion = SerializerVersion.TEXT_COMMAND_VERSION,
  });

  @override
  int getCatrobatImageVersion() => catrobatImageVersion;

  @override
  int getPathCommandVersion() => pathCommandVersion;

  @override
  int getLineCommandVersion() => lineCommandVersion;

  @override
  int getSquareShapeCommandVersion() => squareShapeCommandVersion;

  @override
  int getEllipseShapeCommandVersion() => ellipseShapeCommandVersion;

  @override
  int getStarShapeCommandVersion() => starShapeCommandVersion;

  @override
  int getHeartShapeCommandVersion() => heartShapeCommandVersion;

  @override
  int getSprayCommandVersion() => sprayCommandVersion;

  @override
  int getTextCommandVersion() => textCommandVersion;
}
