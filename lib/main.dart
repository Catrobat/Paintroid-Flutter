import 'package:flutter/material.dart';

import 'pocket_paint.dart';

void main() {
  runApp(const PocketPaintApp());
}

class PocketPaintApp extends StatelessWidget {
  const PocketPaintApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocket Paint',
      theme: ThemeData.from(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0097A7),
          brightness: Brightness.light
        ),
      ),
      darkTheme: ThemeData.from(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00838F),
          brightness: Brightness.dark,
        ),
      ),
      home: const PocketPaint(title: 'Pocket Paint'),
    );
  }
}
