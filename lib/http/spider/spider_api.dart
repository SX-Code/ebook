import 'dart:async';

import 'package:dio/dio.dart';
import 'package:e_book_demo/http/dio_instance.dart';
import 'package:e_book_demo/http/spider/api_string.dart';
import 'package:e_book_demo/model/activity.dart';
import 'package:e_book_demo/model/author.dart';
import 'package:e_book_demo/model/book.dart';
import 'package:e_book_demo/model/review.dart';
import 'package:e_book_demo/model/types.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class SpiderApi {
  static SpiderApi? _instance;

  SpiderApi._();

  static SpiderApi instance() {
    return _instance ??= SpiderApi._();
  }

  /// 获取图书详情数据
  /// [value] 图书信息
  Future fetchBookDetail(
    Book value, {
    Function(Book value)? bookCallback,
    Function(List<Author> values)? authorCallback,
    Function(List<Review> values)? reviewCallback,
    required Function(List<Book> values) similiarBooksCallback,
  }) async {
    String html = await DioInstance.instance()
        .getString(path: '${ApiString.bookDetailUrl}${value.id}');
    Document doc = parse(html);

    if (bookCallback != null) {
      bookCallback.call(_parseBookDetail(value, doc));
    }

    if (authorCallback != null) {
      authorCallback.call(_parseBookAuthors(doc));
    }

    if (reviewCallback != null) {
      reviewCallback.call(_parseBookReview(doc));
    }

    if (reviewCallback != null) {
      similiarBooksCallback.call(_parseSimiliarBook(doc));
    }
  }

  /// 解析豆瓣商城首页数据
  Future fetchDoubanStoreData({
    Function(List<Book> values)? weeklyBooksCallback,
    Function(List<Book> values)? top250Callback,
  }) async {
    String html = await DioInstance.instance()
        .getString(path: ApiString.bookDoubanHomeUrl);
    Document doc = parse(html);

    if (weeklyBooksCallback != null) {
      weeklyBooksCallback.call(_parseWeeklyBooks(doc));
    }

    if (top250Callback != null) {
      top250Callback.call(_parseTop250Books(doc));
    }
  }

  /// 获取豆瓣商城新书速递
  Future<List<Book>> fetchExpressBooks() async {
    Response res = await DioInstance.instance()
        .get(path: ApiString.bookExpressJsonUrl, param: {
      "tag": BookExpressTag.all.value,
    });
    Document doc = parse(res.data['result']);
    // 这里通过解析 JSON 数据中的 html
    return _parseExpressBooks(doc);
  }

  /// 获取读书活动
  /// [kind] 读书活动类型
  Future<List<Activity>> fetchBookActivities(int? kind) async {
    // 全部无需参数
    Map<String, dynamic>? param = kind == null ? null : {"kind": kind};
    Response res = await DioInstance.instance()
        .get(path: ApiString.bookActivitiesJsonUrl, param: param);
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
    String htmlStr = await DioInstance.instance()
        .getString(path: ApiString.bookDoubanHomeUrl);
    Document doc = parse(htmlStr);

    // 解析活动数据
    if (activitiesCallback != null) {
      activitiesCallback.call(parseBookActivities(doc));
    }

    // 解析所有活动标签数据
    if (activityLabelsCallback != null) {
      List<Element> spanEls =
          doc.querySelectorAll('.books-activities .hd .tags .item');
      List<String> labels = [];
      for (Element span in spanEls) {
        labels.add(span.text.trim());
      }
      activityLabelsCallback.call(labels);
    }

    // 解析书籍
    if (booksCallback != null) {
      // 这里则是通过解析豆瓣首页的 html
      booksCallback.call(_parseExpressBooks(doc));
    }
  }

  List<Activity> parseBookActivities(Document doc) {
    List<Element> aEls =
        doc.querySelectorAll('.books-activities .book-activity');
    List<Activity> activities = [];
    for (Element a in aEls) {
      String url = a.attributes['href']?.trim() ?? "";
      String cover = ApiString.getBookActivityCover(a.attributes['style']);
      String title = a.querySelector('.book-activity-title')?.text.trim() ?? "";
      String label = a.querySelector('.book-activity-label')?.text.trim() ?? "";
      String time =
          a.querySelector('.book-activity-time time')?.text.trim() ?? "";
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
  List<Book> _parseExpressBooks(Document doc) {
    List<Book> books = [];
    // 只获取一页
    Element ulEl = doc.querySelectorAll('.books-express .bd .slide-item')[0];
    List<Element> liEls = ulEl.querySelectorAll('li');
    for (Element li in liEls) {
      Element? a = li.querySelector('.cover a');
      // 解析ID
      String id =
          ApiString.getId(a?.attributes['href'], ApiString.bookIdRegExp);
      String cover = a?.querySelector('img')?.attributes['src'] ?? "";
      books.add(Book(
          id: id,
          cover: cover,
          title: li.querySelector('.info .title a')?.text.trim() ?? "",
          authorName: li.querySelector('.info .author')?.text.trim() ?? ""));
    }
    return books;
  }

  /// 解析一周热门图书榜
  List<Book> _parseWeeklyBooks(Document doc) {
    List<Element> liEls = doc.querySelectorAll(".popular-books .bd ul li");
    // 使用map方式
    return liEls.map((li) {
      // 封面
      String? cover = li.querySelector(".cover img")?.attributes['src'];
      // 标题
      Element? aEl = li.querySelector(".title a");
      // innerHtml 和 text 都可以
      String? title = aEl?.innerHtml.trim();
      // ID
      String? id =
          ApiString.getId(aEl?.attributes['href'], ApiString.bookIdRegExp);
      // 作者
      String authorName = li.querySelector(".author")?.innerHtml.trim() ?? "";
      authorName = authorName.replaceFirst("作者：", ""); // 删除 作者：
      // 副标题
      String? subTitle;
      if (title != null && title.isNotEmpty) {
        List titles = title.split('：');
        if (titles.length > 1) {
          title = titles[0];
          subTitle = titles[1];
        } else {
          subTitle = authorName;
        }
      }
      // 评分
      double rate = parseRate(li.querySelector(".average-rating")?.text.trim());
      return Book(
        id: id,
        title: title,
        cover: cover,
        authorName: authorName,
        subTitle: subTitle,
        rate: rate,
      );
    }).toList();
  }

  double parseRate(String? rateStr) {
    if (rateStr == null || rateStr.isEmpty) return 0.0;
    try {
      return double.parse(rateStr);
    } catch (_) {
      return 0.0;
    }
  }

  /// 解析豆瓣图书250
  List<Book> _parseTop250Books(Document doc) {
    // class用 . id用#
    List<Element> dlEls = doc.querySelectorAll("#book_rec dl");
    // 使用map方式
    return dlEls.map((dl) {
      Element aEl = dl.children[0].children[0];
      // 封面
      String? cover = aEl.children[0].attributes['src'];
      // id
      String? id =
          ApiString.getId(aEl.attributes['href'], ApiString.bookIdRegExp);

      return Book(
        id: id,
        cover: cover,
        title: dl.children[1].children[0].text.trim(),
      );
    }).toList();
  }

  /// 解析图书详情
  Book _parseBookDetail(Book value, Document doc) {
    Element? bookEl = doc.querySelector(".subjectwrap");
    if (bookEl == null) return value;
    // 图书定价、页码、评分
    String? text = bookEl.querySelector('#info')?.text.trim();
    // 页码
    value.page = ApiString.getBookPage(text);
    // 定价
    value.price = ApiString.getBookPrice(text);
    // 评分
    value.rate =
        parseRate(bookEl.querySelector(".rating_num")?.text.trim() ?? "");

    // 内容简介
    String desc =
        doc.querySelector(".related_info .all .intro")?.text.trim() ?? "";
    if (desc.isEmpty) {
      // 没有展开按钮
      desc = doc.querySelector(".related_info .intro")?.text.trim() ?? "";
    }
    value.description = desc;

    // 购买信息
    List<Element> buyInfoEls = doc.querySelectorAll(".buyinfo ul li");
    value.buyInfo = buyInfoEls.map((el) {
      // 价格
      String priceStr =
          el.querySelector(".price-wrapper .buylink-price")?.text.trim() ?? "";
      priceStr = priceStr.replaceFirst("元", "");

      return BuyInfo(
          name: el.querySelector(".vendor-name span")?.text,
          price: parseRate(priceStr),
          url: el.querySelector(".vendor-name a")?.attributes['href']);
    }).toList();
    return value;
  }

  // 解析图书作者数据
  List<Author> _parseBookAuthors(Document doc) {
    return [];
  }

  // 解析图书短评
  List<Review> _parseBookReview(Document doc) {
    return [];
  }

  // 解析相似书籍
  List<Book> _parseSimiliarBook(Document doc) {
    return [];
  }
}
