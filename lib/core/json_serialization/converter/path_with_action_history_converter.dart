// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:paintroid/core/commands/path_with_action_history.dart';
import 'package:paintroid/core/json_serialization/converter/path_action_converter.dart';

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
