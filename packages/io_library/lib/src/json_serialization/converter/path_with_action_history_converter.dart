import 'package:command/command.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:io_library/io_library.dart';

class PathWithActionHistoryConverter
    implements JsonConverter<PathWithActionHistory, Map<String, dynamic>> {
  const PathWithActionHistoryConverter();

  @override
  PathWithActionHistory fromJson(Map<String, dynamic> json) {
    var pathWithActionHistory = PathWithActionHistory();
    var actionsJson = json['actions'] as List;
    for (var actionJson in actionsJson) {
      var action = const PathActionConverter()
          .fromJson(actionJson as Map<String, dynamic>);

      if (action is MoveToAction) {
        pathWithActionHistory.moveTo(action.x, action.y);
      } else if (action is LineToAction) {
        pathWithActionHistory.lineTo(action.x, action.y);
      } else if (action is CloseAction) {
        pathWithActionHistory.close();
      }
    }
    return pathWithActionHistory;
  }

  @override
  Map<String, dynamic> toJson(PathWithActionHistory pathWithActionHistory) => {
        'actions': pathWithActionHistory.actions
            .map((action) => const PathActionConverter().toJson(action))
            .toList(),
      };
}
