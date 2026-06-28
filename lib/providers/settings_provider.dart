import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _notificationsEnabled = true;
  bool _darkMode = false;
  bool _autoSync = true;

  bool get notificationsEnabled => _notificationsEnabled;
  bool get darkMode => _darkMode;
  bool get autoSync => _autoSync;
  ThemeMode get themeMode => _darkMode ? ThemeMode.dark : ThemeMode.light;

  void setNotificationsEnabled(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  void setAutoSync(bool value) {
    _autoSync = value;
    notifyListeners();
  }
}
