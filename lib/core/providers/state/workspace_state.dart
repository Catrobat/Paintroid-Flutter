import 'package:freezed_annotation/freezed_annotation.dart';

part 'workspace_state.freezed.dart';

@immutable
@freezed
class WorkspaceState with _$WorkspaceState {
  const factory WorkspaceState({
    required bool isFullscreen,
    required bool isPerformingIOTask,
    required bool hasUnsavedChanges,
    required int commandCountWhenLastSaved,
  }) = _WorkspaceState;
}
