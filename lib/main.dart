import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
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
      home: StyledToast(
        toastAnimation: StyledToastAnimation.fade,
        reverseAnimation: StyledToastAnimation.fade,
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeInOut,
        backgroundColor: Colors.white70,
        toastPositions: const StyledToastPosition(align: Alignment(0, 0.75)),
        duration: const Duration(seconds: 3, milliseconds: 400),
        textStyle: const TextStyle(color: Colors.black),
        borderRadius: BorderRadius.circular(20),
        locale: const Locale('en'),
        child: const PocketPaint(),
      ),
    );
  }
}
