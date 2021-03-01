import 'dart:convert';

import 'package:crux/backend/repository/timer/timer_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static final Preferences _preferences = Preferences._internal();

  static SharedPreferences sharedPreferences;

  factory Preferences() {
    return _preferences;
  }

  Preferences._internal();


  TimerEntity getTimerPreferences(String timerStorageKey) {
    String timerData = sharedPreferences.getString(timerStorageKey);
    if(timerData != null && timerData.isNotEmpty) {
      return TimerEntity.fromJson(json.decode(timerData));
    } else
      return null;
  }

  Future storeTimerPreferences(String timerStorageKey,
      TimerEntity timerEntity) {
    return sharedPreferences.setString(
        timerStorageKey, json.encode(timerEntity.toJson()));
  }

  void removeTimerPreferences(String timerStorageKey) {
    sharedPreferences.getKeys().remove(timerStorageKey);
  }
}
