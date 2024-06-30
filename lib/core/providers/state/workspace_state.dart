import 'package:freezed_annotation/freezed_annotation.dart';

part 'workspace_state.freezed.dart';

@freezed
class WorkspaceState with _$WorkspaceState {
  const factory WorkspaceState({
    @Default(false) bool isFullscreen,
    @Default(false) bool isPerformingIOTask,
    @Default(false) bool hasUnsavedChanges,
    @Default(0) int commandCountWhenLastSaved,
  }) = _WorkspaceState;
}
