import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class IDeviceService {
  Future<ui.Size> getSizeInPixels();

  static final provider = Provider<IDeviceService>((ref) {
    const channel = MethodChannel('org.catrobat.paintroid/device');
    return DeviceService(channel);
  });

  static final sizeProvider = FutureProvider(
    (ref) => ref.watch(provider).getSizeInPixels(),
  );
}

class DeviceService implements IDeviceService {
  DeviceService(this._methodChannel);

  final MethodChannel _methodChannel;

  @override
  Future<ui.Size> getSizeInPixels() async {
    final firstView = WidgetsBinding.instance.platformDispatcher.views.first;
    if (Platform.isAndroid) {
      final height = await _methodChannel.invokeMethod('getHeightInPixels');
      return ui.Size(firstView.physicalSize.width, height);
    } else if (Platform.isIOS) {
      return firstView.physicalSize;
    } else {
      throw 'Unsupported platform';
    }
  }
}
