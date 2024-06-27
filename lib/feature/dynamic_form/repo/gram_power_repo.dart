import 'dart:convert';
import 'dart:developer';

import 'package:aws_s3_polar/feature/dynamic_form/model/gram_power_model.dart';
import 'package:aws_s3_polar/network/api_services.dart';
import 'package:aws_s3_polar/network/controller/network_controller.dart';
import 'package:aws_s3_polar/utility/local_storage/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../network/url_constants.dart';

class GramPowerRepo {
  static Future<GramPowerModel?> getGramPowerData() async {
    if (Get.find<NetworkController>().internetConnectivity) {
      String? response = await ApiService.fetchData(GET_FORM_URL);
      if (response != null) {
        return GramPowerModel.fromRawJson(response);
      }
    }
    return null;
  }

  static Future<bool> saveGramPowerData(Object? body) async {
    bool success = false;
    body ??= json.decode(LocalStorage.getGramPowerAnswer());
    LocalStorage.setGramPowerAnswer("");
    log(body.toString());
    if (Get.find<NetworkController>().internetConnectivity) {
      success = await ApiService.saveData(
        url: POST_FORM_URL,
        body: {"data": body},
        showLoader: true,
      );
    } else {
      LocalStorage.setGramPowerAnswer(body);
      ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
        content: Text(
          'Your data will be saved automatically when an internet connection is established',
        ),
      ));
    }

    return success;
  }
}
