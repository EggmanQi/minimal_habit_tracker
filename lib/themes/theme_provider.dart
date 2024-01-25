import 'package:flutter/material.dart';
import 'dart_mode.dart';
import 'light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  // default is light mode
  ThemeData _themeData = lightMode;

  // define the GET method
  ThemeData get themeDate => _themeData;

  // return current mode states
  bool get isDarkMode => _themeData == darkMode;

  // define the SET method, and send message to all listeners
  // MARK: 不能直接使用 'themeData = value', 原因未明。但把 SET 的方法收到 toggle 中似乎更好
  // set themeDate(ThemeData themeData) {
  //   _themeData = themeData;
  //   notifyListeners();
  // }

  // toggle method for global pages
  void toggleTheme() {
    if (_themeData == lightMode) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
    notifyListeners();
  }
}
