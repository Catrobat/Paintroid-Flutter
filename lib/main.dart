import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/ui/color_schemes.dart';

import 'ui/pocket_paint.dart';

void main() {
  runApp(const ProviderScope(child: PocketPaintApp()));
}

class PocketPaintApp extends StatelessWidget {
  const PocketPaintApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocket Paint',
      theme: ThemeData.from(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme:
          ThemeData.from(useMaterial3: true, colorScheme: darkColorScheme),
      home: const PocketPaint(),
    );
  }
}
