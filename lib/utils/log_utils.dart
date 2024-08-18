import 'dart:developer';

import 'package:flutter/foundation.dart';

///  Name: Log工具类
///  Created by Fitem on 2023/5/31
class LogUtils {

  /// 是否开启日志，默认Debug模式下开启
  static bool isOpenLog = kDebugMode;

  /// 调试打印
  static void println(String obj) {
    if (isOpenLog) debugPrint(obj);
  }

  /// Log 用于网络请求等长内容日志
  static void logger(String obj, {StackTrace? stackTrace, int level = 0}){
    if (isOpenLog) log(obj, stackTrace: stackTrace, level: level);
  }
}