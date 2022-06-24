import 'package:flutter/material.dart';
import 'package:paintroid/ui/theme.dart';

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
      theme: ThemeData.from(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: AppTheme.primary, brightness: Brightness.light),
      ),
      darkTheme: ThemeData.from(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppTheme.primary,
          brightness: Brightness.dark,
        ),
      ),
      home: const PocketPaint(title: 'Pocket Paint'),
    );
  }
}
