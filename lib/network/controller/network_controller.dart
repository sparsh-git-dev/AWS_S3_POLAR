import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  bool internetConnectivity = false;

  /// The function `updateInternetConnectivity` updates the internet connectivity status and triggers an
  /// update if the value has changed.
  ///
  /// Args:
  ///   value (bool): The `value` parameter in the `updateInternetConnectivity` function is a boolean
  /// variable that represents the current state of internet connectivity. It is used to update the
  /// internet connectivity status and trigger an update if there is a change in the connectivity status.
  void updateInternetConnectivity(bool value) {
    if (value != internetConnectivity) {
      log("INTERNET CON _ $value");
      internetConnectivity = value;
      update();
    }
  }

  /// The function `changeConnectivityStatus` checks for different types of connectivity results and
  /// updates the internet connectivity status accordingly.
  ///
  /// Args:
  ///   result (List<ConnectivityResult>): The `result` parameter in the `changeConnectivityStatus`
  /// function is a list of `ConnectivityResult` objects. The function checks the contents of this list to
  /// determine the internet connectivity status based on whether it contains `ConnectivityResult.mobile`,
  /// `ConnectivityResult.wifi`, `Connectivity
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
