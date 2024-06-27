import 'dart:io';

import 'package:camera/camera.dart';
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

    final dir = Directory("${rootPath}Download/Polaris");
    if (!(await dir.exists())) {
      dir.create();
    }
    final String newPath =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final File newImage = File(newPath);

    await newImage.writeAsBytes(await picture.readAsBytes());
    return newImage.path;
  }
}
