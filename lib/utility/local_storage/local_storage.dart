import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Singleton {
  static final Singleton _singleton = Singleton._internal();

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal();
}

class LocalStorage {
  static SharedPreferences? _prefs;
  static Future init() async =>
      _prefs ??= await SharedPreferences.getInstance();

  static Future setGramPowerQuestionnaire(dynamic data) async =>
      await _prefs!.setString(_gramPower, json.encode(data));
  static Future setGramPowerAnswer(dynamic data) async =>
      await _prefs!.setString(_gramPowerAnswer, json.encode(data));
  static Future<String> getGramPowerAnswer() async =>
      _prefs!.getString(_gramPowerAnswer) ?? "";

  static Future getGramPower(String data) async =>
      _prefs!.getString(_gramPower);
}

const String _gramPower = "gram_power";
const String _gramPowerAnswer = "gram_power_answer";
