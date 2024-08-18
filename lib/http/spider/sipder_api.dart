import 'dart:async';
import 'package:dio/dio.dart';
import 'package:e_book_clone/http/dio_instance.dart';
import 'package:e_book_clone/http/spider/api_string.dart';
import 'package:e_book_clone/models/author.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:e_book_clone/models/book_activity.dart';
import 'package:e_book_clone/models/ebook_topic.dart';
import 'package:e_book_clone/models/poetry.dart';
import 'package:e_book_clone/models/review.dart';
import 'package:e_book_clone/models/types.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

/// 爬虫获取数据，解析 DOM 数
class SipderApi {
  static SipderApi? _instance;

  SipderApi._();

  static SipderApi instance() {
    return _instance ??= SipderApi._();
  }

  double parseDouble(String? str) {
    if (str == null || str.isEmpty) return 0.0;
    try {
      return double.parse(str);
    } catch (e) {
      return 0.0;
    }
  }

  /*
    
    豆 瓣 阅 读 

  */
  // 获取豆瓣书评
  Future<List<Review>> fetchEbookReview(String id) async {
    Response res = await DioInstance.instance()
        .get(path: '${ApiString.ebookReviewUrl}/$id/subject_reviews');
    Document document = parse(res.data['html']);
    return _parseEBookReview(document);
  }

  // 获取豆瓣阅读出版，文章详情数据
  Future fetchEBookDetail(
    Book value, {
    Function(Book)? ebookCallback,
    Function(List<Review>)? reviewsCallback,
  }) async {
    // 获取整个网页的代码数据
    String response = await DioInstance.instance().getString(
        path: '${ApiString.ebookDetailUrl}/${value.id}?icn=index-rec');
    Document document = parse(response);

    // 获取书籍详情
    if (ebookCallback != null) {
      _getEBookDetail(document, value, ebookCallback);
    }
  }

  // 电子书商城
  Future fetchStoreData(
      {Function(List<Book> recommend)? recommendCallback,
      Function(List<Category> categories)? categoryCallback}) async {
    String res =
        await DioInstance.instance().getString(path: EBookType.recommand.api);
    Document document = parse(res);

    if (recommendCallback != null) {
      recommendCallback.call(_getEBooksByClass(
          document, EBookType.recommand.clz,
          isRecommand: true));
    }

    if (categoryCallback != null) {
      categoryCallback.call(_getEBookCategories(document));
    }
  }

  // 除了推荐书籍，其他书籍都是 JSON 数据返回，html中保存 html 结构的数据
  Future<List<Book>> fetchStoreEBookTile(EBookType type) async {
    Response res = await DioInstance.instance().get(path: type.api);
    Document document = parse(res.data['html']);
    return _getEBooksByClass(document, type.clz);
  }

  // 获取豆瓣阅读出版，所有话题
  Future<List<EBookTopic>> fetchStoreTopics() async {
    Response res =
        await DioInstance.instance().get(path: ApiString.ebookTopicsSection);
    Document document = parse(res.data['html']);

    List<EBookTopic> topicsMap = [];
    List<Element> topicListEl = document.querySelectorAll('.topic-list');
    for (var i = 0; i < topicListEl.length; i++) {
      Element topicEl = topicListEl[i];
      String? title = topicEl.children[0].firstChild?.text;
      String topicId = ApiString.getTopicId(
          topicEl.children[0].children[1].firstChild?.attributes['href']);
      String total = topicEl.children[0].children[1].firstChild?.text
              ?.replaceFirst('共', '')
              .replaceFirst('部作品', '')
              .trim() ??
          "0";
      if (title == null || title.isEmpty) {
        continue;
      }

      List<Book> books =
          topicEl.querySelectorAll('.slide-list li').map((element) {
        return parseStoreEBook(element, false);
      }).toList();
      // 添加topic
      topicsMap.add(EBookTopic(
        title: title,
        ebooks: books,
        topicId: topicId,
        total: int.parse(total),
      ));
    }

    return topicsMap;
  }

  /// 通过class 获取书籍
  List<Book> _getEBooksByClass(Document document, String? clz,
      {bool isRecommand = false}) {
    if (clz == null || clz.isEmpty) return [];
    List<Book> eBooks = [];
    List<Element>? ulElements =
        document.querySelector('$clz .slide-list')?.children;

    if (ulElements == null) return [];

    int deadIndex = clz == EBookType.newbook.clz ? 1 : 2;
    for (var i = 0; i < ulElements.length; i++) {
      // 最新上架书籍，一页就有10个
      if (i > deadIndex) {
        // 10 个
        break;
      }
      eBooks.addAll(ulElements[i].children.map((element) {
        return parseStoreEBook(element, isRecommand);
      }).toList());
    }
    return eBooks;
  }

  /// 解析具体的书籍信息
  Book parseStoreEBook(Element element, bool isRecommand) {
    String ebookId = ApiString.getId(
        element.querySelector('.pic')?.attributes['href'],
        ApiString.ebookIdRegExp);

    // 推荐数据，从data-src中获取图片链接
    String? img = element
        .querySelector('.pic img')
        ?.attributes[isRecommand ? 'data-src' : 'src'];

    String priceStr =
        element.querySelector('.info .discount-price')?.text ?? "";

    if (priceStr.isEmpty) {
      // 没有特价，尝试获取立减价格
      priceStr = element.querySelector('.info .price-num')?.text ?? "";
      if (priceStr.isEmpty) {
        // 没有立减，获取日常价格
        priceStr = element.querySelector('.info .price-tag')?.text ?? "";
      }
    }
    priceStr = priceStr.replaceFirst('元', '').trim();

    return Book(
      id: ebookId,
      cover: img,
      title: element.querySelector('.info .title a')?.text,
      authorName: element.querySelector('.info .author a')?.text,
      price: parseDouble(priceStr),
    );
  }

  /// 获取电子书的具体详情
  void _getEBookDetail(
      Document document, Book value, Function(Book) ebookCallback) {
    Element? profileEl = document.querySelector('.article-profile-bd');
    if (profileEl == null) return;
    // 副标题
    value.subTitle = profileEl.querySelector('.subtitle')?.text;
    // 字数
    value.labelCount =
        ApiString.getLabelCount(profileEl.querySelector('.article-meta')?.text);
    // 豆瓣评分
    value.rate =
        parseDouble(profileEl.querySelector('.book-rating .score')?.text);

    // 描述
    value.description =
        document.querySelector('.article-profile-intro .bd')?.text;

    // 作品标签
    value.tags = document.querySelectorAll('.tags a').map((element) {
      return Tag(
          name: element.children[0].text,
          count: element.children[1].text,
          url: '${ApiString.ebookBaseUrl}${element.attributes['href']}');
    }).toList();

    ebookCallback.call(value);
  }

  /// 解析电子书 书评
  /// [document] 文档对象
  List<Review> _parseEBookReview(Document document) {
    List<Element> liEls = document.querySelectorAll('.review-item');

    List<Review> reviews = [];
    for (var i = 0; i < liEls.length; i++) {
      if (i > 5) {
        break;
      }
      Element element = liEls[i];
      Element? imgEl = element.querySelector('.avatar img');
      String? rateStr = element
          .querySelector('.info .author .rating-stars')
          ?.attributes['title'];
      double rate = 0;
      if (rateStr != null && rateStr.isNotEmpty) {
        rate = double.parse(rateStr) * 2;
      }
      reviews.add(
        Review(
          author: Author(
            name: imgEl?.attributes['alt'],
            avatar: imgEl?.attributes['src'],
          ),
          short: element.querySelector('.info .desc')?.text,
          date: imgEl?.querySelector('.impression .date')?.text,
          url: element.querySelector('.title a')?.attributes['href'],
          rate: rate,
        ),
      );
    }
    return reviews;
  }

  List<Category> _getEBookCategories(Document document) {
    return document.querySelectorAll('.kinds .kinds-list a').map((item) {
      return Category(
        name: item.text,
        url: item.attributes['href'],
      );
    }).toList();
  }

  /*
    
    豆 瓣 读 书
  
  */
  // 读书活动
  Future<List<BookActivity>> fetchBookActivites(int? kind) async {
    Map<String, dynamic>? param = kind == null ? null : {"kind": kind};
    Response res = await DioInstance.instance()
        .get(path: ApiString.activitiesUrl, param: param);
    Document document = parse(res.data['result']);
    List<BookActivity> activities = [];
    _getBookActivities(document, (List<BookActivity> values) {
      activities = values;
    });
    return activities;
  }

  // 每日一言
  Future<Poetry> fetchDailyPotery() async {
    Response response =
        await DioInstance.instance().get(path: ApiString.dailyPoetry);
    Poetry poetry = Poetry.fromMap(response.data);
    poetry.fetchDate = DateTime.now().microsecondsSinceEpoch;
    return poetry;
  }

  // 拉取豆瓣读书首页，一周热门图书榜
  Future fetchWeekHotBooks(
      {Function(List<Book>)? weeklyBooksCallback,
      Function(List<BookActivity>)? bookActivitiesCallback,
      Function(List<String>)? activityLabelsCallback}) async {
    // 获取整个网页的代码数据
    String response =
        await DioInstance.instance().getString(path: ApiString.baseUrl);
    Document document = parse(response);

    // 读书活动
    if (bookActivitiesCallback != null) {
      _getBookActivities(document, bookActivitiesCallback);
    }

    // 获取每周热门图书
    if (weeklyBooksCallback != null) {
      weeklyBooksCallback.call(_getWeeklyBooks(document));
    }

    if (activityLabelsCallback != null) {
      List<Element> activityLabelEls =
          document.querySelectorAll('.books-activities .tags span');
      List<String> labels = activityLabelEls.map((element) {
        return element.text;
      }).toList();
      activityLabelsCallback.call(labels);
    }
  }

  // 获取豆瓣文章详情数据
  Future fetchBookDetail(
    Book value, {
    Function(Book? book)? bookCallback,
    Function(List<Review>)? reviewsCallback,
    Function(List<Author>)? authorsCallback,
    Function(List<Book>)? similarBooksCallback,
  }) async {
    // 获取整个网页的代码数据
    String response = await DioInstance.instance()
        .getString(path: '${ApiString.bookDetailUrl}${value.id}/');
    Document document = parse(response);

    // 获取书籍详情
    bookCallback?.call(_getBookDetail(document, value));

    // 获取书评
    reviewsCallback?.call(_parseBookReview(document));

    // 获取作者信息
    authorsCallback?.call(_parseBookAuthors(document));

    // 获取相关读者书籍
    similarBooksCallback?.call(_getSimilarBooks(document));
  }

  /// 获取新书速递
  Future<List<Book>> fetchExpressBooks() async {
    // 获取JSON数据，JSON的 result 为 HTML 格式
    Response response = await DioInstance.instance().get(
      path: ApiString.bookExpressUrl,
      param: {"tag": BookExpressType.all.name},
    );
    Document document = parse(response.data['result']);
    return _getExpressBooks(document);
  }

  /// 解析豆瓣阅读首页面数据
  Future fetchDoubanReadBooks(
      {Function(List<Book>)? weeklyBooksCallback,
      Function(List<Book>)? top250BooksCallback}) async {
    String response =
        await DioInstance.instance().getString(path: ApiString.baseUrl);
    Document document = parse(response);

    if (weeklyBooksCallback != null) {
      weeklyBooksCallback.call(_getWeeklyBooks(document));
    }

    if (top250BooksCallback != null) {
      top250BooksCallback.call(_getTop250Books(document));
    }
  }

  /// 解析豆瓣Top250数据
  Future<List<Book>> fetchTop250Books(int page) async {
    String res = await DioInstance.instance().getString(
      path: ApiString.bookTop250Url,
      param: {"start": page * 25},
    );
    Document document = parse(res);

    return document.querySelectorAll('.article table').map((element) {
      List<Element> tds = element.querySelectorAll('td');
      String id = ApiString.getId(
          tds[0].children[0].attributes['href'], ApiString.bookIdRegExp);

      // 解析价格
      List<String> pl = tds[1].children[1].text.split('/');
      String price = pl[pl.length - 1];
      price = price.replaceFirst('元', '');
      price = price.replaceFirst('CNY', '');

      // 解析副标题
      String subtitle;
      if (tds[1].children.length < 4) {
        // 没有副标题，取作者
        subtitle = pl[0];
      } else {
        subtitle = tds[1].children[3].text.trim();
      }

      return Book(
        id: id,
        cover: tds[0].children[0].children[0].attributes['src'],
        title: tds[1].children[0].children[0].text.trim(),
        price: parseDouble(price.trim()),
        rate: parseDouble(tds[1].children[2].children[1].text.trim()),
        subTitle: subtitle,
      );
    }).toList();
  }

  /// 解析更多不同 subcat 的新书速递

  Future<List<Book>> fetchSubcatExpressBooks(
      Map<String, String> param, String path) async {
    String res =
        await DioInstance.instance().getString(path: path, param: param);
    Document document = parse(res);

    return document.querySelectorAll('.chart-dashed-list li').map((element) {
      Element? aEl = element.children[0].querySelector('a');
      String id =
          ApiString.getId(aEl?.attributes['href'], ApiString.bookIdRegExp);
      Element body = element.children[1];

      List<String> abstract = body.children[1].text.split(' / ');
      String priceStr = abstract[abstract.length - 2].replaceFirst('元', '');

      return Book(
        id: id,
        cover: aEl?.children[0].attributes['src'],
        title: body.children[0].children[0].text.trim(),
        subTitle: abstract[0].trim(),
        price: parseDouble(priceStr),
        rate: parseDouble(body.children[2].children[1].text),
      );
    }).toList();
  }

  void _getBookActivities(
      Document document, Function(List<BookActivity>) bookActivitiesCallback) {
    List<Element> activityEls =
        document.querySelectorAll('.books-activities .book-activity');
    Element activityEl;
    List<BookActivity> bookActivities = [];
    for (var i = 0; i < activityEls.length; i++) {
      activityEl = activityEls[i];
      String bg = ApiString.getBookActivitiesBg(activityEl.attributes['style']);
      bookActivities.add(BookActivity(
          bg: bg,
          url: activityEl.attributes['href'],
          title: activityEl.querySelector('.book-activity-title')?.text.trim(),
          label: activityEl.querySelector('.book-activity-label')?.text.trim(),
          time: activityEl.querySelector('.book-activity-time time')?.text));
    }

    bookActivitiesCallback.call(bookActivities);
  }

  List<Book> _getExpressBooks(Document document) {
    // 选取第二个子元素，即展示在首页的数据
    Element? divEl = document.querySelector('.slide-list');

    List<Element> liEls = divEl?.children[0].children ?? [];
    List<Book> books = liEls.map((element) {
      Node? aNode = element.children[0].querySelector('a');
      String id =
          ApiString.getId(aNode?.attributes['href'], ApiString.bookIdRegExp);

      Element infoElement = element.children[1];
      return Book(
        id: id,
        cover: aNode?.children[0].attributes['src'],
        title: infoElement.children[0].children[0].text,
        authorName: infoElement.children[1].text.trim(),
      );
    }).toList();
    return books;
  }

  List<Book> _getWeeklyBooks(Document document) {
    List<Element> liElments =
        document.querySelectorAll('div.popular-books ul.list-summary li');
    List<Book> books = liElments.map((li) {
      // 解析数据
      Element? titleAEl = li.querySelector('.title a');
      String id =
          ApiString.getId(titleAEl?.attributes['href'], ApiString.bookIdRegExp);
      String img = li.querySelector('.cover img')?.attributes['src'] ?? "";

      String? subtitle;
      String? title = titleAEl?.innerHtml;
      if (title != null && title.isNotEmpty) {
        List titles = title.split('：');
        if (titles.length > 1) {
          title = titles[0];
          subtitle = titles[1];
        }
      }

      String authorName = li.querySelector('.author')?.text ?? "";
      authorName = authorName.replaceFirst('作者：', '').trim();
      subtitle ??= authorName;
      double rate = parseDouble(li.querySelector('.average-rating')?.innerHtml);
      // 创建数据
      return Book(
          id: id,
          cover: img,
          title: title,
          subTitle: subtitle,
          authorName: authorName,
          rate: rate);
    }).toList();

    return books;
  }

  /// 解析首页的 TOP250 数据
  List<Book> _getTop250Books(Document document) {
    List<Element> dlEls = document.querySelectorAll('#book_rec dl');

    return dlEls.map((element) {
      Element? aEl = element.children[0].children[0];
      String id =
          ApiString.getId(aEl.attributes['href'], ApiString.bookIdRegExp);
      return Book(
          id: id,
          cover: aEl.children[0].attributes['src'],
          title: element.children[1].children[0].text.trim());
    }).toList();
  }

  /// 解析图书详情
  Book? _getBookDetail(Document document, Book value) {
    Element? bookEl = document.querySelector('.subjectwrap');
    // 获取书籍详情, 定价、页数
    if (bookEl != null) {
      String text = bookEl.querySelector('#info')?.text ?? "";
      int page = ApiString.getBookPage(text);
      double price = ApiString.getBookPrice(text);

      // 解析评分
      value.rate ??=
          parseDouble(bookEl.querySelector('.rating_num')?.text.trim());
      String desc =
          document.querySelector('.related_info .all .intro')?.text.trim() ??
              "";
      if (desc.isEmpty) {
        // 没有展开选项
        desc =
            document.querySelector('.related_info .intro')?.text.trim() ?? "";
      }
      desc = desc.replaceAll('【内容简介】', '');

      // 购买信息
      List<Element> storeEls =
          document.querySelectorAll('.buyinfo .bs .price-btn-wrapper');
      List<BuyInfo> byInfoList = storeEls.map((item) {
        String priceStr = item
                .querySelector(
                    '.impression_track_mod_buyinfo .price-wrapper span')
                ?.text ??
            "";
        double price = parseDouble(priceStr.replaceFirst('元', '').trim());

        return BuyInfo(
          name: item.querySelector('.vendor-name span')?.text,
          price: price,
          url: item.querySelector('.vendor-name a')?.attributes['href'],
        );
      }).toList();

      Book book = Book(
        id: value.id,
        cover: value.cover,
        title: value.title,
        rate: value.rate,
        page: page,
        price: price,
        subTitle: value.subTitle,
        description: desc,
        buyInfo: byInfoList,
      );

      return book;
    }
    return null;
  }

  List<Review> _parseBookReview(Document document) {
    List<Element> reviewEls = document.querySelectorAll('.review-list>div');
    List<Review> reviews = [];
    for (var i = 0; i < reviewEls.length; i++) {
      // 最多取5条
      if (i >= 5) {
        break;
      }
      Element current = reviewEls[i];

      String? avatar = current
          .querySelector('.avator')
          ?.querySelector('img')
          ?.attributes['src'];
      double? rate = Review.getRage(
          current.querySelector('.main-title-rating')?.attributes['title'] ??
              "");
      String short = current.querySelector('.short-content')?.text ?? "";
      short = short.replaceFirst('(展开)', '');
      if (short.contains('这篇书评可能有关键情节透露')) {
        short =
            '【这篇书评可能有关键情节透露】\n${short.replaceFirst('这篇书评可能有关键情节透露', '').trimLeft()}';
      }

      reviews.add(Review(
        id: current.querySelector('.review-item')?.attributes['id'],
        author: Author(
          name: current.querySelector('.name')?.text,
          avatar: avatar,
        ),
        rate: rate,
        short: short.trim(),
        date: current.querySelector('.main-meta')?.text,
      ));
    }
    return reviews;
  }

  List<Author> _parseBookAuthors(Document document) {
    List<Element> liEls = document.querySelectorAll(".authors-list .author");
    List<Author> authors = [];
    // 忽略最后一个li.fake
    for (int i = 0; i < liEls.length - 1; i++) {
      Element li = liEls[i];
      // 作者ID
      String authorId = ApiString.getId(
          li.children[0].attributes['href'], ApiString.authorIdRegExp);
      Element infoEl = li.children[1];

      authors.add(Author(
        id: authorId,
        avatar: li.children[0].children[0].attributes['src'],
        name: infoEl.children[0].text, // 作者姓名
        role: infoEl.children[1].text, // 角色
      ));
    }
    return authors;
  }

  List<Book> _getSimilarBooks(Document document) {
    List<Element> knnlikeEls =
        document.querySelectorAll('.knnlike .content dl');
    List<Book> similarBoos = [];

    for (Element item in knnlikeEls) {
      if (item.className != 'clear') {
        Element? titleEl = item.querySelector('dd a');
        String? title;
        String? subtitle;
        String? bookId;
        if (titleEl != null) {
          title = titleEl.text.trim();
          List titles = title.split('：');
          if (titles.length > 1) {
            // 存在副标题
            title = titles[0];
            subtitle = titles[1];
          } else if (titles.isNotEmpty) {
            // 只有标题
            title = title[0];
          }
          bookId = ApiString.getId(
              titleEl.attributes['href'], ApiString.bookIdRegExp);
        }
        similarBoos.add(Book(
          id: bookId,
          title: title,
          subTitle: subtitle,
          rate: parseDouble(item.querySelector('.subject-rate')?.text),
          cover: item.querySelector('img')?.attributes['src'],
        ));
      }
    }

    return similarBoos;
  }
}
