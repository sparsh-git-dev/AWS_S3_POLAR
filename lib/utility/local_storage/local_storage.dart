import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static final GetStorage _prefs = GetStorage();
  static Future setGramPowerQuestionnaire(dynamic data) async =>
      await _prefs.write(_gramPower, json.encode(data));
  static String getGramPowerQuestionnaire() => _prefs.read(_gramPower) ?? "";
  static Future setGramPowerAnswer(dynamic data) async =>
      await _prefs.write(_gramPowerAnswer, json.encode(data));
  static String getGramPowerAnswer() => _prefs.read(_gramPowerAnswer) ?? "";

  static Future getGramPower(String data) async => _prefs.read(_gramPower);
}

const String _gramPower = "gram_power";
const String _gramPowerAnswer = "gram_power_answer";
