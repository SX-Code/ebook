import 'dart:async';
import 'package:e_book_clone/http/spider/json_api.dart';
import 'package:e_book_clone/models/ebookshelf.dart';
import 'package:e_book_clone/models/types.dart';
import 'package:e_book_clone/models/user_info.dart';
import 'package:e_book_clone/utils/constants.dart';
import 'package:e_book_clone/utils/shared_prefs_utils.dart';
import 'package:e_book_clone/utils/toast_utils.dart';
import 'package:flutter/material.dart';

class MyBookViewModel with ChangeNotifier {
  EBookshelf? _reading;
  EBookshelf? _unreading;
  String? _userId;

  EBookshelf? get reading => _reading;
  EBookshelf? get unreading => _unreading;

  set reading(EBookshelf? reading) {
    _reading = reading;
    notifyListeners();
  }

  set unreading(EBookshelf? unreading) {
    _unreading = unreading;
    notifyListeners();
  }

  set userId(String? userId) {
    _userId = userId;
  }

  Future getUserInfo() async {
    return SharedPrefsUtils.getObject(Constants.keyUserInfo, UserInfo.fromJson);
  }

  Future getData(VoidCallback? needLoginCallback) async {
    if (_userId == null || _userId!.isEmpty) {
      UserInfo? userInfo = await getUserInfo();
      if (userInfo == null) {
        ToastUtils.showErrorMsg('登录后更精彩');
        return;
      }
      _userId = userInfo.id;
    }
    // 获取继续阅读数据
    getReadingBooks(_userId!).then((needLogin) {
      if (needLogin) {
        ToastUtils.showErrorMsg('请重新登录');
        needLoginCallback?.call();
      } else {
        getUnReadingBooks(_userId!);
      }
    });
  }

  Future<bool> getReadingBooks(String userId) async {
    Map<String, dynamic> variables = {
      "userId": userId,
      "progress": EBookProgressType.reading.value,
    };
    EBookshelf? res = await JsonApi.instance()
        .fetchBookshelfBook(variables, 0);
    if (res == null) {
      // 出错
      reading = EBookshelf(
          total: 0, books: []);
      return true;
    }
    reading = res;
    return false;
  }

  Future<bool> getUnReadingBooks(String userId) async {
    Map<String, dynamic> variables = {
      "userId": userId,
      "progress": EBookProgressType.never.value,
    };
    EBookshelf? res = await JsonApi.instance()
        .fetchBookshelfBook(variables, 0);
    if (res == null) {
      // 出错
      unreading = EBookshelf(
          total: 0, books: []);
      return true;
    }
    unreading = res;
    return false;
  }
}
