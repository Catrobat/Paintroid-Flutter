import 'package:flutter/material.dart';
import 'package:paintroid/ui/color_schemes.g.dart';

import 'ui/pocket_paint.dart';

void main() {
  runApp(const PocketPaintApp());
}

class PocketPaintApp extends StatelessWidget {
  const PocketPaintApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocket Paint',
      theme: ThemeData.from(useMaterial3: true, colorScheme: lightColorScheme),
      home: const PocketPaint(title: 'Pocket Paint'),
    );
  }
}
