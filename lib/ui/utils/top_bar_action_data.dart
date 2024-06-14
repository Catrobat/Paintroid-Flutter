// Flutter imports:
import 'package:flutter/material.dart';

class TopBarActionData {
  final String name;
  final IconData iconData;

  const TopBarActionData._(
    this.name,
    this.iconData,
  );

  static const CHECKMARK = TopBarActionData._(
    'CheckMarkButton',
    Icons.check,
  );

  static const PLUS = TopBarActionData._(
    'PlusButton',
    Icons.add,
  );
}
