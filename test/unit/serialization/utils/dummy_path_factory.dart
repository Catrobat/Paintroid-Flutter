// Project imports:
import 'package:paintroid/core/commands/path_with_action_history.dart';

class DummyPathFactory {
  static PathWithActionHistory createPathWithActionHistory(
      int numberOfActions) {
    PathWithActionHistory pathWithActionHistory = PathWithActionHistory();
    for (int i = 0; i < numberOfActions; i++) {
      pathWithActionHistory.moveTo(i.toDouble(), i.toDouble() + 1);
      pathWithActionHistory.lineTo(i.toDouble() + 2, i.toDouble() + 3);
    }
    pathWithActionHistory.close();
    return pathWithActionHistory;
  }
}
