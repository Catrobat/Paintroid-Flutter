import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';
import 'package:paintroid/core/json_serialization/versioning/version_strategy.dart';

class DummyVersionStrategy implements IVersionStrategy {
  final int pathCommandVersion;
  final int lineCommandVersion;
  final int catrobatImageVersion;
  final int squareShapeCommandVersion;
  final int ellipseShapeCommandVersion;
  final int sprayCommandVersion;
  final int clipboardCommandVersion;
  final int deleteRegionCommandVersion;

  DummyVersionStrategy({
    this.pathCommandVersion = SerializerVersion.PATH_COMMAND_VERSION,
    this.catrobatImageVersion = SerializerVersion.CATROBAT_IMAGE_VERSION,
    this.lineCommandVersion = SerializerVersion.LINE_COMMAND_VERSION,
    this.squareShapeCommandVersion =
        SerializerVersion.SQUARE_SHAPE_COMMAND_VERSION,
    this.ellipseShapeCommandVersion =
        SerializerVersion.ELLIPSE_SHAPE_COMMAND_VERSION,
    this.sprayCommandVersion = SerializerVersion.SPRAY_COMMAND_VERSION,
    this.clipboardCommandVersion = SerializerVersion.CLIPBOARD_COMMAND_VERSION,
    this.deleteRegionCommandVersion = SerializerVersion.DELETE_REGION_COMMAND_VERSION,
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
  int getSprayCommandVersion() => sprayCommandVersion;

  @override
  int getClipboardCommandVersion() => clipboardCommandVersion;

  @override
  int getDeleteRegionCommandVersion() => deleteRegionCommandVersion;
}
