import 'package:aws_s3_polar/feature/dynamic_form/model/gram_power_model.dart';
import 'package:aws_s3_polar/feature/dynamic_form/repo/gram_power_repo.dart';
import 'package:aws_s3_polar/network/controller/network_controller.dart';
import 'package:aws_s3_polar/utility/local_storage/local_storage.dart';
import 'package:get/get.dart';

class FormScreenController extends GetxController {
  GramPowerModel? model;
  // Show loader on screen
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  set updateLoading(bool v) {
    _isLoading = v;
    update(["main"]);
  }

// Run a background check to see if an internet connection is available and
// there's data to send to the API.
  onBackgroundTask() async {
    final connectivityResult = Get.find<NetworkController>();
    if (connectivityResult.internetConnectivity) {
      String pending = LocalStorage.getGramPowerAnswer();
      if (pending.isNotEmpty) {
        await GramPowerRepo.saveGramPowerData(null);
      }
    }
  }

// Validate required fields without relying on widget keys like CaptureImage
  bool _validate = false;
  bool get isValidateFields => _validate;
  set updateValidate(bool v) {
    _validate = v;
    update(["main"]);
  }

  /// The function `validateFields` checks if certain fields are filled based on required condition and
  /// returns a boolean indicating if the validation is successful.
  ///
  /// Returns:
  ///   The `validateFields()` function returns a boolean value indicating whether all the fields in the
  /// model are valid based on certain conditions. If all fields are valid, it returns `true`; otherwise,
  /// it returns `false`.
  bool validateFields() {
    updateValidate = true;
    bool valid = true;
    for (Field e in model?.fields ?? []) {
      if ((e.answers?.isEmpty ?? false) &&
          e.metaInfo.mandatory == "yes" &&
          e.componentType == "CheckBoxes") {
        valid = false;
      } else if (e.answer.isEmpty &&
          e.metaInfo.mandatory == "yes" &&
          e.componentType != "CheckBoxes") {
        valid = false;
      }
    }
    update();

    return valid;
  }

  /// The `reset` function updates loading and validation flags and retrieves a GramPowerModel from local
  /// storage.
  void reset() {
    updateLoading = true;
    updateValidate = false;
    model =
        GramPowerModel.fromRawJson(LocalStorage.getGramPowerQuestionnaire());
    updateLoading = false;
  }

  /// The fetchGramPowerData function fetches GramPower data, stores it locally if available, and
  /// handles cases of no internet connectivity.
  Future<void> fetchGramPowerData() async {
    model = await GramPowerRepo.getGramPowerData();
    if (model != null) {
      LocalStorage.setGramPowerQuestionnaire(model!.toJson());
    }
    // NO internet connectivity
    model ??=
        GramPowerModel.fromRawJson(LocalStorage.getGramPowerQuestionnaire());
    updateLoading = false;
  }

  /// The `saveData` function asynchronously saves data by converting model fields to a payload and then
  /// saving it using `GramPowerRepo`.
  Future saveData() async {
    List<Map> payloadData =
        List.from((model?.fields ?? []).map((e) => e.toPostPayload()));
    await GramPowerRepo.saveGramPowerData(payloadData);
  }

  /// The function `uploadImage` asynchronously uploads an image file and returns a nullable string.
  ///
  /// Args:
  ///   filePath (String): The `filePath` parameter is a string that represents the file path of the
  /// image that you want to upload.
  ///
  /// Returns:
  ///   The `uploadImage` function is returning a `Future<String?>`.
  Future<String?> uploadImage(String filePath) async {
    return await GramPowerRepo.uploadImage(filePath);
  }
}
