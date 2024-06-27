import 'dart:async';

import 'package:dio/dio.dart';
import 'package:e_book_demo/http/dio_instance.dart';
import 'package:e_book_demo/http/spider/api_string.dart';
import 'package:e_book_demo/model/activity.dart';
import 'package:e_book_demo/model/book.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class SpiderApi {
  static SpiderApi? _instance;

  SpiderApi._();

  static SpiderApi instance() {
    return _instance ??= SpiderApi._();
  }


  /// 获取读书活动
  /// [kind] 读书活动类型
  Future<List<Activity>> fetchBookActivities(int? kind) async {
    // 全部无需参数
    Map<String, dynamic>? param = kind == null ? null : {"kind": kind};
    Response res = await DioInstance.instance().get(path: ApiString.bookActivitiesJsonUrl, param: param);
    String htmlStr = res.data['result'];
    Document doc = parse(htmlStr);
    return parseBookActivities(doc);
  }

  /// 获取首页数据
  Future fetchHomeData({
    Function(List<Activity> values)? activitiesCallback,
    Function(List<String> values)? activityLabelsCallback,
    Function(List<Book> values)? booksCallback,
  }) async {
    String htmlStr = await DioInstance.instance().getString(path: ApiString.bookDoubanHomeUrl);
    Document doc = parse(htmlStr);

    // 解析活动数据
    if (activitiesCallback != null) {
      activitiesCallback.call(parseBookActivities(doc));
    }

    // 解析所有活动标签数据
    if (activityLabelsCallback != null) {
      List<Element> spanEls =  doc.querySelectorAll('.books-activities .hd .tags .item');
      List<String> labels = [];
      for (Element span in spanEls) {
        labels.add(span.text.trim());
      }
      activityLabelsCallback.call(labels);
    }

    // 解析书籍
    if (booksCallback != null) {
      booksCallback.call(parseHomeBooks(doc));
    }
    
  }

  List<Activity> parseBookActivities(Document doc) {
    List<Element> aEls = doc.querySelectorAll('.books-activities .book-activity');
    List<Activity> activities = [];
    for (Element a in aEls) {
      String url = a.attributes['href']?.trim() ?? "";
      String cover = ApiString.getBookActivityCover(a.attributes['style']);
      String title = a.querySelector('.book-activity-title')?.text.trim() ?? "";
      String label = a.querySelector('.book-activity-label')?.text.trim() ?? "";
      String time = a.querySelector('.book-activity-time time')?.text.trim() ?? "";
      activities.add(Activity(
        url: url,
        cover: cover,
        title: title,
        label: label,
        time: time,
      ));
    }
    return activities;
  }
  
  /// 解析首页书籍数据
  List<Book> parseHomeBooks(Document doc) {
    List<Book> books = [];
    // 只获取一页
    Element ulEl = doc.querySelectorAll('.books-express .bd .slide-item')[0];
    List<Element> liEls = ulEl.querySelectorAll('li');
    for (Element li in liEls) {
      Element? a = li.querySelector('.cover a');
      // 解析ID
      String id = ApiString.getId(a?.attributes['href'], ApiString.bookIdRegExp);
      String cover = a?.querySelector('img')?.attributes['src'] ?? "";
      books.add(Book(
        id: id,
        cover: cover,
        title: li.querySelector('.info .title a')?.text.trim() ?? "",
        authorName: li.querySelector('.info .author')?.text.trim() ?? ""
      ));
    }
    return books;
  }

}