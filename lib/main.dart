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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    subscription.cancel();
    super.dispose();
  }

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
