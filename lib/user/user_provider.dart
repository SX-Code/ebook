import 'package:e_book_clone/models/user_info.dart';
import 'package:e_book_clone/utils/constants.dart';
import 'package:e_book_clone/utils/shared_prefs_utils.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserInfo? _userInfo;

  UserInfo? get userInfo => _userInfo;
  
  set userInfo(UserInfo? userInfo) {
    _userInfo = userInfo;
    notifyListeners();
  }

  void setUserInfo(UserInfo userInfo) {
    _userInfo = userInfo;
    notifyListeners();
  }

  
  Future initUserInfo() async {
    UserInfo? res = await SharedPrefsUtils.getObject(Constants.keyUserInfo, UserInfo.fromJson);
    if (res == null) return;
    userInfo = res;
  }

  Future clearUserInfo() async {
    userInfo = null;
    // 移除 cookie
    SharedPrefsUtils.remove(Constants.keyCookie);
    // 移除用户信息
    SharedPrefsUtils.remove(Constants.keyUserInfo);
  }
}
