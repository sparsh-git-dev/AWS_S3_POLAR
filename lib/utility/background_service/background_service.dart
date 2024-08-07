import 'package:polaris/feature/dynamic_form/repo/gram_power_repo.dart';
import 'package:polaris/network/controller/network_controller.dart';
import 'package:polaris/utility/local_storage/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackgroundService {
  BackgroundService._internal();
  static final BackgroundService _singleton = BackgroundService._internal();
  factory BackgroundService() => _singleton;

  void handle(AppLifecycleState state) async {
    final controller = Get.find<NetworkController>();
    if ((state == AppLifecycleState.resumed ||
            state == AppLifecycleState.paused) &&
        controller.internetConnectivity &&
        LocalStorage.getGramPowerAnswer().isNotEmpty) {
      // await GramPowerRepo.saveGramPowerData(null);
    }
  }
}
