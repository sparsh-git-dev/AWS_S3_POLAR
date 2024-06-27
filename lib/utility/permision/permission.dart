import 'dart:io';

import 'package:aws_s3_polar/utility/dialog_service/dialog_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermission {
  static Future<bool> cameraPermissionsGranted() async {
    var permission = await Permission.camera.status;

    if (permission.isGranted) {
      return true;
    } else if (permission.isPermanentlyDenied) {
      await openAppSettings();
    } else if (permission.isDenied) {
      permission = await Permission.camera.request();
    }

    return permission.isGranted;
  }

  static Future<bool> getStoragePermission(context) async {
    try {
      bool permissionGranted = false;

      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo? androidInfo =
          Platform.isAndroid ? await deviceInfo.androidInfo : null;
      if (androidInfo != null && androidInfo.version.sdkInt >= 33) {
        permissionGranted = await Permission.photos.request().isGranted;
        // await Permission.manageExternalStorage.request().isGranted;
      } else {
        var permission = await Permission.storage.request();
        permissionGranted = permission.isGranted;

        if (permission.isGranted) {
          permissionGranted = true;
        } else if (permission.isPermanentlyDenied) {
          DialogService()
              .confirmAlertDialogWithoutTitle(
                  "Storage Permission",
                  "You have permanently denied storage permission to this app. Do you want to enable storage access from mobile settings?",
                  "No",
                  "Yes")
              .then((action) async {
            if (action == true) {
              await openAppSettings();
              permission = await Permission.storage.request();
            }
          });
        } else if (permission.isDenied) {
          permissionGranted = false;
        }
      }
      return permissionGranted;
    } on Exception {
      rethrow;
    }
  }

  static Future<bool> _requestPermission(
      Permission permission, String title, String message) async {
    var status = await permission.status;

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      bool userChoseToOpenSettings =
          await DialogService().confirmAlertDialogWithoutTitle(
        title,
        message,
        "No",
        "Yes",
      );

      if (userChoseToOpenSettings) {
        await openAppSettings();
        return await permission.status.isGranted;
      }
      return false;
    } else if (status.isDenied) {
      Permission.manageExternalStorage.request();
      return await permission.status.isGranted;
    }
    return false;
  }
}
