// Project imports:
import 'package:paintroid/core/json_serialization/versioning/serializer_version.dart';
import 'package:paintroid/core/json_serialization/versioning/version_strategy.dart';

class DummyVersionStrategy implements IVersionStrategy {
  final int drawPathCommandVersion;
  final int catrobatImageVersion;

  DummyVersionStrategy(
      {this.drawPathCommandVersion =
          SerializerVersion.DRAW_PATH_COMMAND_VERSION,
      this.catrobatImageVersion = SerializerVersion.CATROBAT_IMAGE_VERSION});

  @override
  int getCatrobatImageVersion() => catrobatImageVersion;

  @override
  int getDrawPathCommandVersion() => drawPathCommandVersion;
}
