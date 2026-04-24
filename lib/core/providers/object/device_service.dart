import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class IDeviceService {
  static final sizeProvider = Provider<ui.Size>((ref) {
    throw UnimplementedError();
  });
}

class DeviceService {
  static const _channel = MethodChannel('org.catrobat.paintroid/device');
  static const ui.Size _testSize = ui.Size(1179, 2556);

  static Future<ui.Size> getSizeInPixels() async {
    final firstView = WidgetsBinding.instance.platformDispatcher.views.first;
    if (Platform.isAndroid) {
      final height = await _channel.invokeMethod('getHeightInPixels');
      return ui.Size(firstView.physicalSize.width, height);
    } else if (Platform.isIOS) {
      return firstView.physicalSize;
    } else {
      return _testSize;
    }
  }
}
