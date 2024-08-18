import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_book_clone/http/dio_instance.dart';
import 'package:e_book_clone/http/spider/api_string.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:e_book_clone/models/ebookshelf.dart';
import 'package:e_book_clone/models/douban_ebook.dart';
import 'package:e_book_clone/models/query_param.dart';
import 'package:e_book_clone/models/suggest.dart';
import 'package:e_book_clone/models/types.dart';
import 'package:e_book_clone/models/user_info.dart';

/// 获取 JSON 格式数据
class JsonApi {
  static JsonApi? _instance;

  JsonApi._();

  static JsonApi instance() {
    return _instance ??= JsonApi._();
  }

  /// 获取相似书籍
  /// [bookId] 与该ID相似的书籍
  Future<List<Book>> fetchSimilarEbooks(String bookId) async {
    EBookshelfParam param = EBookshelfParam(
      query: EBookshelfParam.similiarQuery,
      operationName: EBookshelfParam.getWorks,
      variables: {"worksId": bookId},
    );
    Response res = await DioInstance.instance().get(
      path: ApiString.ebookGraphqlUrl,
      data: jsonEncode(param),
      param: {"name": EBookshelfParam.similiarQuery},
    );
    List<Book> books = [];
    List list = res.data['data']['works']['similarWorksList'];
    for (dynamic book in list) {
      books.add(Book.fromSimilar(book));
    }
    return books;
  }

  /// 获取更多 电子图书
  /// [query] 查询参数
  /// [type] 哪种更多页面
  Future<ResultDoubanList> fetchMoreEBook(QueryParam query, MorePageType type,
      {String? topicId}) async {
    String path = type.path;
    if (type == MorePageType.topic) {
      path = path.replaceFirst('#', topicId.toString());
    }
    Response res =
        await DioInstance.instance().get(path: path, data: jsonEncode(query));
    return ResultDoubanList.fromJson(res.data);
  }

  /// 获取用户信息
  Future<UserInfo> fetchUsedrInfo() async {
    Response res =
        await DioInstance.instance().get(path: ApiString.ebookUserInfoJsonUrl);
    return UserInfo.fromDoubanJson(res.data);
  }

  /// 查询所有书架数据
  /// [userId] 用户ID
  /// [type] all: 全部，Never: 未读, Reading: 未读完, Finished: 已读完
  Future<EBookshelf?> fetchBookshelfBook(
      Map<String, dynamic> variables, int page) async {
    List<String>? ids = await fetchBookshelfIds(variables);
    // 登录出错
    if (ids == null) return null;

    List twoList = splitList(ids, 7);

    if (twoList.length <= page) {
      // 没有更多数据了
      return EBookshelf(total: 0, books: []);
    }

    EBookshelfParam param = EBookshelfParam(
      query: EBookshelfParam.bookshelfQuery,
      operationName: EBookshelfParam.getWorksList,
      variables: {},
    );
    // 按照每7个长度请求，官网长度
    List worksIds = twoList[page];

    param.variables = {
      "worksIds": worksIds,
    };
    // 请求书籍进度
    Map<String, int> progressMap = await fetchBooshelfProgress(worksIds);
    // 请求书籍信息
    Response res = await DioInstance.instance().get(
      path: ApiString.ebookGraphqlUrl,
      data: jsonEncode(param),
      param: {"name": EBookshelfParam.getWorksList},
    );
    List list = res.data['data']['worksList'];
    List<Book> books = [];
    for (Map json in list) {
      books.add(Book.fromBookshelf(json, progressMap[json['id']] ?? 0));
    }
    return EBookshelf(total: ids.length, books: books);
  }

  /// 获取书籍阅读进度
  /// [ids] 待获取书籍的ID
  Future<Map<String, int>> fetchBooshelfProgress(List ids) async {
    EBookshelfParam param = EBookshelfParam(
      query: EBookshelfParam.booshelfProgress,
      operationName: EBookshelfParam.getProgressWorksList,
      variables: {
        "worksIds": ids,
      },
    );
    Response res = await DioInstance.instance().get(
      path: ApiString.ebookGraphqlUrl,
      data: jsonEncode(param),
      param: {"name": EBookshelfParam.getProgressWorksList},
    );
    List list = res.data['data']['worksList'];
    Map<String, int> map = <String, int>{};
    for (Map json in list) {
      map[json['id'] as String] = json['progressRatio'] as int;
    }
    return map;
  }

  /// 获取书架所有ID
  /// [variables] 请求参数
  Future<List<String>?> fetchBookshelfIds(
      Map<String, dynamic> variables) async {
    EBookshelfParam param = EBookshelfParam(
        query: EBookshelfParam.bookshelfIdsQuery,
        operationName: EBookshelfParam.getWorksIds,
        variables: variables);

    Response res = await DioInstance.instance().get(
      path: ApiString.ebookGraphqlUrl,
      data: jsonEncode(param),
      param: {"name": EBookshelfParam.getWorksIds},
    );
    if (res.data is String) {
      return [];
    }
    if (res.data['errors'] != null) {
      return null;
    }
    List list = res.data['data']['user']['bookshelf']['libraryList']['list'];
    List<String> bookIds = [];
    for (Map worksId in list) {
      bookIds.add(worksId['worksId']);
    }
    return bookIds;
  }

  List splitList(List list, int len) {
    if (len <= 1) {
      return [list];
    }
    List result = [];
    int index = 1;
    while (true) {
      if (index * len < list.length) {
        List temp = list.skip((index - 1) * len).take(len).toList();
        result.add(temp);
        index++;
        continue;
      }
      List temp = list.skip((index - 1) * len).toList();
      result.add(temp);
      break;
    }
    return result;
  }

  /// 搜索建议
  /// [keyword] 搜索关键词
  Future<List<Suggest>> fetchSuggestV3(String keyword) async {
    Response res = await DioInstance.instance()
        .get(path: ApiString.ebookSearchSuggestJsonUrl, param: {"q": keyword});
    List<Suggest> suggests = [];
    for (dynamic suggest in res.data) {
      if (suggest['type'] == "keyword") {
        suggests.add(Suggest.fromJson(suggest['data']));
      }
    }
    return suggests;
  }

  /// 获取搜索结果
  /// [param] 搜索参数
  Future<List<Book>> fetchEbookSearch(SearchParam param) async {
    Response res = await DioInstance.instance().get(path: ApiString.ebookSearchJsonUrl, data: jsonEncode(param));
    List list = res.data['list'];
    List<Book> books = [];
    for (dynamic json in list) {
      books.add(Book.fromDoubanJson(json));
    }
    return books;
  }
}
