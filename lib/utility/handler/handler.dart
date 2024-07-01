import 'dart:io';

import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class ImageHandler {
  static Future<String> savePictureToFolder(
      XFile picture, String folderName) async {
    Directory targetDirectory =
        await getExternalStorageDirectory() ?? Directory("");

    List<String> externalPathList = targetDirectory.path.split('/');
    int posOfDir = externalPathList.indexOf('Android');
    String rootPath = externalPathList.sublist(0, posOfDir).join('/');
    rootPath += "/";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo? androidInfo =
        Platform.isAndroid ? await deviceInfo.androidInfo : null;
    late Directory dir;
    if (androidInfo != null && androidInfo.version.sdkInt >= 33) {
      dir = Directory("${rootPath}Download/$folderName");
      if (!(await dir.exists())) {
        dir.create();
      }
    } else {
      dir = targetDirectory;
    }

    final String newPath =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final File newImage = File(newPath);

    await newImage.writeAsBytes(await picture.readAsBytes());
    return newImage.path;
  }
}
