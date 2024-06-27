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
  /// This function retrieves GramPower data if there is internet connectivity and returns it as a
  /// GramPowerModel object, otherwise it returns null.
  ///
  /// Returns:
  ///   The `getGramPowerData` function returns a `Future` that resolves to a `GramPowerModel` object or
  /// `null`.
  static Future<GramPowerModel?> getGramPowerData() async {
    if (Get.find<NetworkController>().internetConnectivity) {
      String? response = await ApiService.fetchData(GET_FORM_URL);
      if (response != null) {
        return GramPowerModel.fromRawJson(response);
      }
    }
    return null;
  }

  /// The `saveGramPowerData` function checks for internet connectivity, saves data locally if no
  /// connection is available, uploads images to cloudinary if necessary, and then sends the data to an
  /// API endpoint for saving.
  ///
  /// Args:
  ///   body (Object): The `saveGramPowerData` function takes an `Object? body` parameter, which
  /// represents the data to be saved. This function first checks for internet connectivity using
  /// `NetworkController` and if there is no internet connection and the `body` is not null, it saves the
  /// data locally using `
  ///
  /// Returns:
  ///   The `saveGramPowerData` function returns a `Future<bool>` value.
  static Future<bool> saveGramPowerData(Object? body) async {
    if (!Get.find<NetworkController>().internetConnectivity && body != null) {
      LocalStorage.setGramPowerAnswer(body);
      ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
        content: Text(
          'Your data will be saved automatically when an internet connection is established',
        ),
      ));
      return false;
    }
    bool success = false;
    body ??= json.decode(LocalStorage.getGramPowerAnswer());

    // If `answer` does not contains https,
    // this means the local path is saved in the field,
    // The image needs get uploaded to cloudinary
    if (body != null) {
      // log(body.runtimeType as String);
      for (var e in body as List) {
        if (e["component_type"] == "CaptureImages" &&
            e["answer"].isNotEmpty &&
            !e["answer"].contains("http")) {
          e["answer"] = await uploadImage(e["answer"]);
        }
      }
    }

    success = await ApiService.saveData(
      url: POST_FORM_URL,
      body: {"data": body},
      showLoader: true,
    );
    if (success) {
      LocalStorage.setGramPowerAnswer("");
    }

    return success;
  }

  /// The function `uploadImage` uploads an image to Cloudinary if there is internet connectivity,
  /// otherwise it returns null.
  ///
  /// Args:
  ///   filePath (String): The `filePath` parameter in the `uploadImage` function represents the path to
  /// the image file that you want to upload to a cloud service. This parameter should be a string that
  /// specifies the location of the image file on the device's storage.
  ///
  /// Returns:
  ///   If there is internet connectivity, the function will return the result of uploading the image to
  /// Cloudinary using the `uploadCloudinary` method from the `ApiService` class with `showLoader` set to
  /// true. If there is no internet connectivity, the function will return null.
  static Future<String?> uploadImage(String filePath) async {
    if (Get.find<NetworkController>().internetConnectivity) {
      return await ApiService.uploadCloudinary(filePath, showLoader: true);
    }
    return null;
  }
}
