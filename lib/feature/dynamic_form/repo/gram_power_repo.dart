import 'package:aws_s3_polar/feature/dynamic_form/model/gram_power_model.dart';
import 'package:aws_s3_polar/network/api_services.dart';
import 'package:aws_s3_polar/utility/connectivity_service/connectivity.dart';
import 'package:aws_s3_polar/utility/local_storage/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../network/url_constants.dart';

class GramPowerRepo {
  static Future<GramPowerModel?> getGramPowerData() async {
    String? response = await ApiService.fetchData(GET_FORM_URL);
    if (response != null) {
      return GramPowerModel.fromRawJson(response);
    }
    return null;
  }

  static Future<bool> saveGramPowerData(Object? body) async {
    bool success = false;
    body ??= LocalStorage.getGramPowerAnswer();
    LocalStorage.setGramPowerAnswer("");
    if (await InternetConnectivity.checkConnectivity()) {
      bool success = await ApiService.saveData(
        url: POST_FORM_URL,
        body: {"data": body},
        showLoader: true,
      );
    } else {
      LocalStorage.setGramPowerAnswer(body);
    }

    return success;
  }
}
