import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/loggable_mixin.dart';
import 'package:permission_handler/permission_handler.dart';

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
      "Permissions for this platform have not been handled";

  @override
  Future<bool> requestAccessToSharedFileStorage() async {
    if (Platform.isIOS || Platform.isAndroid) {
      const permission = Permission.storage;
      final status = await permission.request();
      return _didGrant(status, Permission.storage);
    } else {
      logger.severe(_unhandledPlatformErrorMsg);
      return false;
    }
  }

  @override
  Future<bool> requestAccessToPickPhotos() async {
    late final Permission permission;
    if (Platform.isIOS) {
      permission = Permission.photos;
    } else if (Platform.isAndroid) {
      permission = Permission.storage;
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
      permission = Permission.storage;
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
        logger.warning("User has been restricted for $permission");
        break;
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.denied:
        logger.warning("User explicitly denied $permission");
        break;
    }
    return false;
  }
}
