import 'package:paintroid/core/models/path_model.dart';

class DummyPathFactory {
  static PathModel createPathModel(int numberOfActions) {
    PathModel pathModel = PathModel();
    for (int i = 0; i < numberOfActions; i++) {
      pathModel.moveTo(i.toDouble(), i.toDouble() + 1);
      pathModel.lineTo(i.toDouble() + 2, i.toDouble() + 3);
    }
    pathModel.close();
    return pathModel;
  }
}
