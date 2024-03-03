import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;
  ThemeMode _themeMode;

  ThemeNotifier(this._themeData, this._themeMode);

  ThemeData getTheme() => _themeData;
  ThemeMode getThemeMode() => _themeMode;

  void setTheme(ThemeData themeData, ThemeMode themeMode) {
    _themeData = themeData;
    _themeMode = themeMode;
    notifyListeners();
  }
}

