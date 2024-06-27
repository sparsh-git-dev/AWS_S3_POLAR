import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  bool internetConnectivity = false;
  void updateInternetConnectivity(bool value) {
    if (value != internetConnectivity) {
      log("INTERNET CON _ $value");
      internetConnectivity = value;
      update();
    }
  }

  void changeConnectivityStatus(List<ConnectivityResult> result) {
    bool internetAccess = result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.vpn);
    if (internetAccess) {
      updateInternetConnectivity(true);
    } else if (result.contains(ConnectivityResult.none)) {
      updateInternetConnectivity(false);
    }
  }
}
