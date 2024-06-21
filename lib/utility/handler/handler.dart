import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class Handler {
  static CameraController? _controller;
  static late Future<void> _initializeControllerFuture;

  static Future<void> initializeController() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      return;
    }
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller!.initialize();
  }

  static Future<void> takePicture() async {
    if (_controller != null) {
      try {
        XFile picture = await _controller!.takePicture();
        await savePicture(picture.path);
      } on CameraException catch (e) {
        print(e);
      }
    } else {
      log('Camera not initialized');
    }

    // if (!_controller!.value.isRecordingVideo) {

    // }
  }

  static Future<void> savePicture(String path) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now()}.png';
    final imagepath = File(directory.path + fileName);
    await imagepath.writeAsBytes(await File(path).readAsBytes());
  }

  // Future<void> createPolarisSurveyFolder(String endPoint) async {
  //   final path = await getExternalStorageDirectory();
  //   final directory = Directory("${path ?? ""}$endPoint");
  //   if (!await directory.exists()) {
  //     await directory.create();
  //   }
  //    final fileName = '${DateTime.now()}.png';
  //     final imagepath = File(directory.path + fileName);
  //   await imagepath.writeAsBytes(await File(path).readAsBytes());
  // }
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
