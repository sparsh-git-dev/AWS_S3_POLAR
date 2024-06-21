import 'package:aws_s3_polar/feature/dynamic_form/model/gram_power_model.dart';
import 'package:aws_s3_polar/feature/dynamic_form/repo/gram_power_repo.dart';
import 'package:aws_s3_polar/utility/local_storage/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormScreenController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GramPowerModel? model;
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  set updateLoading(bool v) {
    _isLoading = v;
    update(["main"]);
  }

  bool _validate = false;
  bool get isValidate => _validate;
  set updateValidate(bool v) {
    _isLoading = v;
    update(["main"]);
  }

  Future<void> fetchGramPowerData() async {
    model = await GramPowerRepo.getGramPowerData();
    // TODO : Assign data from local if No internet
    if (model != null) {
      LocalStorage.setGramPowerQuestionnaire(model!.toJson());
    }
    updateLoading = false;
  }

  Future saveData() async {
    List<Map> payloadData = [];
    for (Field e in model?.fields ?? []) {
      payloadData.add({
        // ...e.metaInfo.toJson(),
        "answer":
            e.answers?.isNotEmpty ?? false ? e.answers!.join(", ") : e.answer
      });
    }
    bool success = await GramPowerRepo.saveGramPowerData(payloadData);
    // if (success) {
    //   Get.back();
    // }
    print(payloadData.map((e) => print(e.toString())));
  }
}
