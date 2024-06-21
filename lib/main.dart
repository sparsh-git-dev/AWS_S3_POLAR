import 'package:aws_s3_polar/feature/dynamic_form/view/form_screen.dart';
import 'package:aws_s3_polar/utility/local_storage/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //  FlutterBackgroundService.initialize(onStart);
  await LocalStorage.init();
  // await Workmanager().initialize(
  //   onBackgroundTask,
  //   // isInDebugMode: true, // Callback function for the task
  //   // Optional data to pass to the task
  // );
  // await Handler.initializeController();
  runApp(const MyApp());
}

onBackgroundTask() async {
  // final connectivityResult = await Connectivity().checkConnectivity();
  // if (connectivityResult.contains(ConnectivityResult.mobile) ||
  //     connectivityResult.contains(ConnectivityResult.wifi)) {
  //   String pending = await LocalStorage.getGramPowerAnswer();
  //   if (pending.isNotEmpty) {
  //     await GramPowerRepo.saveGramPowerData(null);
  //   }
  // } else {}
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
