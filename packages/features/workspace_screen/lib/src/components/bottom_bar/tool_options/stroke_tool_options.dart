// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:workspace_screen/workspace_screen.dart';

class StrokeToolOptions extends StatelessWidget {
  const StrokeToolOptions({super.key});
  @override
  Widget build(BuildContext context) {
    return const Column(children: [
      StrokeWidthToolOption(),
      Spacer(),
      StrokeCapToolOption(),
    ]);
  }
}
