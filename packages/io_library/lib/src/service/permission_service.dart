// Dart imports:
import 'dart:io';

// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:io_library/io_library.dart';

abstract class IPermissionService {
  Future<bool> requestAccessToPickPhotos();

  Future<bool> requestAccessForSavingToPhotos();

  Future<bool> requestAccessToSharedFileStorage();

  static final provider = Provider<IPermissionService>(
    (ref) => PermissionService(),
  );
}

class PermissionService with LoggableMixin implements IPermissionService {
  static const _unhandledPlatformErrorMsg =
      'Permissions for this platform have not been handled';

  Future<bool> _isAndroidVersionGreaterOrEqualTo(int version) async {
    if (!Platform.isAndroid) return false;
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt >= version;
  }

  @override
  Future<bool> requestAccessToSharedFileStorage() async {
    late final Permission permission;
    if (Platform.isIOS) {
      permission = Permission.photos;
    } else if (Platform.isAndroid) {
      if (await _isAndroidVersionGreaterOrEqualTo(33)) {
        permission = Permission.photos;
      } else {
        permission = Permission.storage;
      }
    } else {
      logger.severe(_unhandledPlatformErrorMsg);
      return false;
    }
    final status = await permission.request();
    return _didGrant(status, permission);
  }

  @override
  Future<bool> requestAccessToPickPhotos() async {
    late final Permission permission;
    if (Platform.isIOS) {
      permission = Permission.photos;
    } else if (Platform.isAndroid) {
      if (await _isAndroidVersionGreaterOrEqualTo(33)) {
        permission = Permission.photos;
      } else {
        permission = Permission.storage;
      }
    } else {
      logger.severe(_unhandledPlatformErrorMsg);
      return false;
    }
    final status = await permission.request();
    return _didGrant(status, permission);
  }

  @override
  Future<bool> requestAccessForSavingToPhotos() async {
    late final Permission permission;
    if (Platform.isIOS) {
      permission = Permission.photosAddOnly;
    } else if (Platform.isAndroid) {
      if (await _isAndroidVersionGreaterOrEqualTo(33)) {
        permission = Permission.photos;
      } else {
        permission = Permission.storage;
      }
    } else {
      logger.severe(_unhandledPlatformErrorMsg);
      return false;
    }
    final status = await permission.request();
    return _didGrant(status, permission);
  }

  bool _didGrant(PermissionStatus status, Permission permission) {
    switch (status) {
      case PermissionStatus.limited:
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.restricted:
        logger.warning('User has been restricted for $permission');
        break;
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.denied:
        logger.warning('User explicitly denied $permission');
        break;
      default:
        logger
            .warning('Undefinied permission status. This should never happen.');
        break;
    }
    return false;
  }
}
