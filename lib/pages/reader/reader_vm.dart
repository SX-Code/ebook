import 'package:e_book_clone/style/ebook_reader_js.dart';
import 'package:e_book_clone/utils/constants.dart';
import 'package:e_book_clone/utils/shared_prefs_utils.dart';
import 'package:flutter/material.dart';

class ReaderViewModel with ChangeNotifier {
  static const List themes = [
    Color(0xFFFFFFFF),
    Color(0xFFE0D9C5),
    Color(0xFFD7E3CB),
    Color(0xFFCED8E4),
    Color(0xFF121212),
  ];
  // 对于上面的颜色代码
  static const List themeStr = [
    '#FFFFFF',
    '#E0D9C5',
    '#D7E3CB',
    '#CED8E4',
    '#121212',
  ];

  Color? currColor;
  int _currIndex = 0;
  int prevIndex = 0;
  int _currFontSize = 19;
  int _currLineHeight = 32;
  static final int _lastIndex = themes.length - 1;
  String? _themeClassName;

  int get currIndex => _currIndex;
  int get currFontSize => _currFontSize;
  int get currLineHeight => _currLineHeight;
  static int get lastIndex => _lastIndex;

  init(isDark) async {
    if (isDark) {
      _currIndex = themes.length - 1;
    } else {
      _currIndex = await SharedPrefsUtils.getInt(Constants.keyReaderThemeIndex);
    }
    currColor = themes[_currIndex];
    _currFontSize =
        await SharedPrefsUtils.getInt(Constants.keyReaderFontSize, 19);
    _currLineHeight =
        await SharedPrefsUtils.getInt(Constants.keyReaderLineHeight, 32);
    notifyListeners();
  }

  set currIndex(int index) {
    _currIndex = index;
    currColor = themes[index];
    notifyListeners();
    if (index != themes.length - 1) {
      // 不报错黑色主题，黑色主题由当前主题决定
      SharedPrefsUtils.putInt(Constants.keyReaderThemeIndex, index);
    }
  }

  set currFontSize(int currFontSize) {
    _currFontSize = currFontSize;
    SharedPrefsUtils.putInt(Constants.keyReaderFontSize, currFontSize);
  }

  set currLineHeight(int currLineHeight) {
    _currLineHeight = currLineHeight;
    SharedPrefsUtils.putInt(Constants.keyReaderLineHeight, currLineHeight);
  }

  String get themeClassName {
    if (_themeClassName == null) {
      StringBuffer buf = StringBuffer();
      for (var i = 0; i < themes.length; i++) {
        buf.write('theme$i ');
      }
      _themeClassName = buf.toString();
    }
    return _themeClassName!;
  }

  /// 生成所有主题css样式代码，添加新主题，调用此方法重新生成
  String generateThemeCode() {
    StringBuffer buf = StringBuffer();
    for (var i = 0; i < themes.length; i++) {
      String colorStr = themes[i].toString();
      String valueString = colorStr.split('Color(0xff')[1].split(')')[0];
      String textColor = '#000000';
      if (i == themes.length - 1) {
        textColor = '#ffffff';
      }
      buf.write(EbookReaderJsCss.instance()
          .generateThemeCode('theme$i', '#$valueString', textColor));
    }
    return buf.toString();
  }

  /// 生成默认主题css样式代码，添加新主题，调用此方法重新生成
  String generateDefaultThemStyle() {
    String bgColor;
    String textColor;
    if (_currIndex == _lastIndex) {
      textColor = '#ffffff';
      bgColor = themeStr[_lastIndex];
    } else {
      bgColor = themeStr[_currIndex];
      textColor = '#000000';
    }
    var style = EbookReaderJsCss.instance()
        .getDefaultDarkCss(textColor, bgColor, _currFontSize, _currLineHeight);
    return style;
  }
}
