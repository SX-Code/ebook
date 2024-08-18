import 'package:e_book_clone/http/dio_instance.dart';
import 'package:e_book_clone/pages/root_page.dart';
import 'package:e_book_clone/theme/theme_provider.dart';
import 'package:e_book_clone/user/user_provider.dart';
import 'package:e_book_clone/utils/log_utils.dart';
import 'package:e_book_clone/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Size get designSize {
  final firstView = WidgetsBinding.instance.platformDispatcher.views.first;
  // 逻辑短边
  final logicalShortestSide =
      firstView.physicalSize.shortestSide / firstView.devicePixelRatio;
  // 逻辑长边
  final logicalLongestSide =
      firstView.physicalSize.longestSide / firstView.devicePixelRatio;
  // 缩放比例 designSize越小，元素越大
  const scaleFactor = 0.95;
  return Size(
      logicalShortestSide * scaleFactor, logicalLongestSide * scaleFactor);
}

class MyAPP extends StatefulWidget {
  const MyAPP({super.key});

  @override
  State<MyAPP> createState() => _MyAPPState();
}

class _MyAPPState extends State<MyAPP> {
  @override
  void initState() {
    Provider.of<ThemeProvider>(context, listen: false).init();
    DioInstance.instance().initDio();
    Provider.of<UserProvider>(context, listen: false).initUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (context, child) {
        LogUtils.println("width: ${40.w}, height: ${40.h}");
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: ToastUtils.navigatorKey,
          home: const RootPage(),
          theme: Provider.of<ThemeProvider>(context).themeData,
          darkTheme:
              Provider.of<ThemeProvider>(context, listen: false).isSystemTheme
                  ? Provider.of<ThemeProvider>(context).darkTheme
                  : null,
          localizationsDelegates: const [
            RefreshLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) => locale,
          supportedLocales: const [
            Locale('en', 'US'), // 美国英语
            Locale('zh', 'CN') // 简体中文
          ],
        );
      },
    );
  }
}
