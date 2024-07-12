import 'dart:io';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';


abstract class INativeCatrobatService{
  Future<ByteData> getNativeClassData(String parameter);
  
  static final provider = Provider<INativeCatrobatService>((ref)
  {
    const channel= MethodChannel('org.catrobat.paintroid/native');
    return NativeCatrobatService(channel);
  });
}





class NativeCatrobatService implements INativeCatrobatService {
  NativeCatrobatService(this._methodChannel);

  final MethodChannel _methodChannel;
  @override
  Future<ByteData> getNativeClassData(String parameter) async  {
    if(Platform.isAndroid) {
        try {
          final ByteData data = await _methodChannel.invokeMethod('getNativeClassData', {'path': parameter});
          return data;
        } catch (e) {
          print('Failed to get native class data: $e');
          throw e;  // Re-throw to allow caller to handle the exception.
        }
      }
    throw UnimplementedError();
  }

}




