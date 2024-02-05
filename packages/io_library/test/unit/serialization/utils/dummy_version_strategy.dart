import 'package:io_library/io_library.dart';

class DummyVersionStrategy implements IVersionStrategy {
  final int pathCommandVersion;
  final int catrobatImageVersion;

  DummyVersionStrategy(
      {this.pathCommandVersion = SerializerVersion.PATH_COMMAND_VERSION,
      this.catrobatImageVersion = SerializerVersion.CATROBAT_IMAGE_VERSION});

  @override
  int getCatrobatImageVersion() => catrobatImageVersion;

  @override
  int getPathCommandVersion() => pathCommandVersion;
}
