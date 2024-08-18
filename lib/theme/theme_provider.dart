import 'package:e_book_clone/theme/dark_theme.dart';
import 'package:e_book_clone/theme/light_theme.dart';
import 'package:e_book_clone/utils/constants.dart';
import 'package:e_book_clone/utils/shared_prefs_utils.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;
  bool _showDialyPoetry = false;
  bool _isSystemTheme = true;

  ThemeData get themeData => _themeData;
  bool get showDialyPoetry => _showDialyPoetry;
  bool get isSystemTheme => _isSystemTheme;
  ThemeData get lightTheme => lightMode;
  ThemeData get darkTheme => darkMode;

  init() async {
    _isSystemTheme =
        await SharedPrefsUtils.getBool(Constants.keyIsSystemTheme, true);
    bool isDark = await SharedPrefsUtils.getBool(Constants.isDarkTheme, false);
    if (isDark) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
    showDialyPoetry = await SharedPrefsUtils.getBool(
        Constants.keyShowDailyPoetry, showDialyPoetry);
    notifyListeners();
  }

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  set showDialyPoetry(bool showDialyPoetry) {
    _showDialyPoetry = showDialyPoetry;
    notifyListeners();
  }

  set isSystemTheme(bool isSystemTheme) {
    _isSystemTheme = isSystemTheme;
    SharedPrefsUtils.putBool(Constants.keyIsSystemTheme, isSystemTheme);
    notifyListeners();
  }

  bool get isDarkMode => _themeData == darkMode;

  void setThemeDataNoNotify(bool isDark) {
    if (isDark) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
    SharedPrefsUtils.putBool(Constants.isDarkTheme, isDarkMode);
  }

  void switch2Dest(bool is2Dart) {
    if (is2Dart) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
    SharedPrefsUtils.putBool(Constants.isDarkTheme, is2Dart);
  }

  void closeSystemTheme() {
    // 关闭
    isSystemTheme = false;
  }

  // switch方法
  void toggleIsSystemTheme(BuildContext context) {
    // 切换状态
    if (isSystemTheme) {
      isSystemTheme = false;
    } else {
      isSystemTheme = true;
    }
    if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
        _themeData = darkMode;
      } else {
        _themeData = lightMode;
      }
    SharedPrefsUtils.putBool(Constants.isDarkTheme, isDarkMode);
  }

  Future toggleShowDailyPoetry() async {
    showDialyPoetry = !showDialyPoetry;
    SharedPrefsUtils.putBool(Constants.keyShowDailyPoetry, showDialyPoetry);
  }
}
