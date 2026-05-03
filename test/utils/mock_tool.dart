import 'package:mockito/mockito.dart';
import 'package:paintroid/core/enums/tool_types.dart';
import 'package:paintroid/core/tools/tool.dart';

class MockTool extends Mock implements Tool {
  @override
  final ToolType type;

  MockTool(this.type);
}
