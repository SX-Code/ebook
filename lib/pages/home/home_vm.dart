import 'dart:async';
import 'package:e_book_clone/http/spider/sipder_api.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:e_book_clone/models/book_activity.dart';
import 'package:e_book_clone/models/poetry.dart';
import 'package:e_book_clone/utils/constants.dart';
import 'package:e_book_clone/utils/shared_prefs_utils.dart';
import 'package:flutter/material.dart';

class HomeViewModel with ChangeNotifier {
  Poetry? _poetry;
  List<Book>? _weeklyBooks;
  List<String>? _activityLabels;
  List<BookActivity>? _bookActivities;

  Poetry? get poetry => _poetry;
  List<Book>? get weeklyBooks => _weeklyBooks;
  List<String>? get activityLabels => _activityLabels;
  List<BookActivity>? get bookActivities => _bookActivities;


  set poetry(Poetry? poetry) {
    _poetry = poetry;
    notifyListeners();
  }

  set activityLabels(List<String>? activityLabels) {
    _activityLabels = activityLabels;
    notifyListeners();
  }

  set weeklyBooks(List<Book>? weeklyBooks) {
    _weeklyBooks = weeklyBooks;
    notifyListeners();
  }

  set bookActivities(List<BookActivity>? bookActivities) {
    _bookActivities = bookActivities;
    notifyListeners();
  }

  // 每日一诗
  Future getDailyPotery() async {
    String poetryStr =
        await SharedPrefsUtils.getString(Constants.keyDailyPoetry);
    // 首次获取
    if (poetryStr.isEmpty) {
      poetry = await SipderApi.instance().fetchDailyPotery();
      SharedPrefsUtils.putString(
          Constants.keyDailyPoetry, poetry?.toJson() ?? "");
    } else {
      // 判断今日是否已获取
      Poetry old = Poetry.fromJson(poetryStr);
      if (old.fetchDate != null &&
          DateTime.now().day ==
              DateTime.fromMicrosecondsSinceEpoch(old.fetchDate!).day) {
        poetry = old;
      } else {
        poetry = await SipderApi.instance().fetchDailyPotery();
        SharedPrefsUtils.putString(
            Constants.keyDailyPoetry, poetry?.toJson() ?? "");
      }
    }
  }

  // 获取推荐书籍
  Future getSpecialForYouBooks() async {
    await SipderApi.instance().fetchWeekHotBooks(
      weeklyBooksCallback: (List<Book> values) => (weeklyBooks = values),
      bookActivitiesCallback: (List<BookActivity> activities) =>
          (bookActivities = activities),
      activityLabelsCallback: (List<String> values) =>
          (activityLabels = values),
    );
  }

  Future getActivityByKind(int? kind) async {
    bookActivities = await SipderApi.instance().fetchBookActivites(kind);
  }
}
