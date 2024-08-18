import 'package:e_book_clone/app.dart';
import 'package:e_book_clone/database/my_sqlite.dart';
import 'package:e_book_clone/pages/bottom_nav_provider.dart';
import 'package:e_book_clone/theme/theme_provider.dart';
import 'package:e_book_clone/user/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化数据库
  MySqlite.forFeature();
  // 强制竖屏
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ],
  ).then((value) {
    runApp(
      MultiProvider(providers: [
        // 主题
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        // 用户
        ChangeNotifierProvider(create: (context) => UserProvider()),

        ChangeNotifierProvider(create: (context) => BottomNavProvider()),
      ], child: const MyAPP()),
    );
  });
}
