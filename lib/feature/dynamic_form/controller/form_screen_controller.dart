import 'package:aws_s3_polar/feature/dynamic_form/model/gram_power_model.dart';
import 'package:aws_s3_polar/feature/dynamic_form/repo/gram_power_repo.dart';
import 'package:aws_s3_polar/utility/local_storage/local_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FormScreenController extends GetxController {
  XFile? myfile;

  GramPowerModel? model;
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  set updateLoading(bool v) {
    _isLoading = v;
    update(["main"]);
  }

  onBackgroundTask() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      String pending = await LocalStorage.getGramPowerAnswer();
      if (pending.isNotEmpty) {
        await GramPowerRepo.saveGramPowerData(null);
      }
    } else {}
  }

  bool _validate = false;
  bool get isValidate => _validate;
  set updateValidate(bool v) {
    _validate = v;
    update(["main"]);
  }

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

  void reset() {
    updateLoading = true;
    updateValidate = false;
    model =
        GramPowerModel.fromRawJson(LocalStorage.getGramPowerQuestionnaire());
    updateLoading = false;
  }

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

  Future saveData() async {
    List<Map> payloadData =
        List.from((model?.fields ?? []).map((e) => e.toPostPayload()));
    await GramPowerRepo.saveGramPowerData(payloadData);
  }
}
