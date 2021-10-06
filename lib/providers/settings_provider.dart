import 'package:flutter/material.dart';
import 'package:news/db/db.dart';
import 'package:news/models/models.dart';

enum SettingsKeys {
  navigationBarStyle,
  openInExternalBroswer,
}

class SettingsProvider with ChangeNotifier {
  final Map<SettingsKeys, dynamic> _settings;

  SettingsProvider() : _settings = {} {
    _settings[SettingsKeys.navigationBarStyle] = BottomNavigationBarType.shifting;
    _settings[SettingsKeys.openInExternalBroswer] = true;
    _fetchFromDB();
  }

  Future<dynamic> _getValueFromDB(SettingsKeys key) async {
    var first = await DBHelper.first(where: "key = ?", whereArgs: [key.index]);
    return first?['value'];
  }

  Future<void> _fetchFromDB() async {
    _settings[SettingsKeys.navigationBarStyle] = (await _getValueFromDB(SettingsKeys.navigationBarStyle)) ?? BottomNavigationBarType.shifting;
    _settings[SettingsKeys.openInExternalBroswer] = (await _getValueFromDB(SettingsKeys.openInExternalBroswer)) ?? true;
    notifyListeners();
  }

  dynamic getSetting(SettingsKeys key) {
    if (_settings.containsKey(key)) {
      print(_settings[key]!.runtimeType);
      return _settings[key]!;
    }
    return "";
  }

  void setSetting(SettingsKeys key, dynamic value) async {
    _settings[key] = value;
    await DBHelper.insert({'key': key.index, 'value': value.toString()});
    notifyListeners();
  }
}
