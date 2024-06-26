import 'package:e_book_demo/pages/theme/dart_theme.dart';
import 'package:e_book_demo/pages/theme/light_theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;
  ThemeData get ligthTheme => lightMode;
  ThemeData get dartTheme => darkMode;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  /// 切换主题
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}