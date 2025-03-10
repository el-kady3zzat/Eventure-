import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalNotificationSettings {
  static late SharedPreferences _prefs;
  void init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void setSettings(Map<String, bool> settings) {
    // Convert Map to JSON String before saving
    String jsonString = jsonEncode(settings);
    _prefs.setString('settings', jsonString);
  }

  Map<String, bool> getSettings() {
    String? jsonString = _prefs.getString('settings');

    if (jsonString == null) return {};

    // Decode JSON string into Map
    Map<String, dynamic> decodedMap = jsonDecode(jsonString);

    // Convert dynamic values to bool explicitly
    return decodedMap.map((key, value) => MapEntry(key, value as bool));
  }
}
