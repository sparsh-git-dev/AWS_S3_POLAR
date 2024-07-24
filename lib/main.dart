import 'dart:async';
import 'package:polaris/feature/dynamic_form/view/form_screen.dart';
import 'package:polaris/network/controller/network_controller.dart';

import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polaris/utility/background_service/background_service.dart';

/// The below function initializes the Flutter application and runs the MyApp widget.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  CloudinaryObject cloudinaryObject =
      CloudinaryObject.fromCloudName(cloudName: "dnhopswdo");
  late StreamSubscription<List<ConnectivityResult>> subscription;
  late NetworkController controller;

  /// The `initState` function in Dart initializes a network controller and listens for changes in
  /// connectivity status.
  @override
  void initState() {
    super.initState();
    controller = Get.put(NetworkController());
    WidgetsBinding.instance.addObserver(this);
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      controller.changeConnectivityStatus(result);
    });
  }

  /// The dispose function removes an observer and cancels a subscription before calling the superclass's
  /// dispose method.
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    subscription.cancel();
    super.dispose();
  }

  /// The function `didChangeAppLifecycleState` in Dart is used to handle changes in the app's lifecycle
  /// state by calling the `handle` method of the `BackgroundService` class.
  ///
  /// Args:
  ///   state (AppLifecycleState): The `state` parameter in the `didChangeAppLifecycleState` method
  /// represents the current lifecycle state of the application. It is of type `AppLifecycleState`, which
  /// is an enum that defines the possible states of an application's lifecycle, such as `resumed`,
  /// `inactive`, `paused`,
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    BackgroundService().handle(state);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        backgroundColor: Colors.green[100],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SvgPicture.asset(
                  "assets/polar.svg",
                  height: 60,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 160),
                child: OutlinedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.greenAccent[200])),
                    onPressed: () => Navigator.push(
                        Get.context!,
                        MaterialPageRoute(
                            builder: (ctx) => const FormScreen())),
                    child: const Text("ENTER")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
