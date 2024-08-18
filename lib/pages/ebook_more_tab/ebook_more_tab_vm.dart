import 'package:e_book_clone/http/spider/json_api.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:e_book_clone/models/douban_ebook.dart';
import 'package:e_book_clone/models/query_param.dart';
import 'package:e_book_clone/models/types.dart';
import 'package:flutter/material.dart';

// 获取 JSON 数据
class EBookMoreViewModel with ChangeNotifier {
  List<Book>? _more;
  int? _total;
  int _currentPage = 1;

  List<Book>? get more => _more;
  int? get total => _total;

  // 获取更多页面的数据
  Future getMoreEBook(QueryParam query, bool loadMore, MorePageType type, {String? topicId}) async {
    if (loadMore) {
      _currentPage++;
    } else {
      _currentPage = 1;
    }

    query.page = _currentPage;
    ResultDoubanList res =
        await JsonApi.instance().fetchMoreEBook(query, type, topicId: topicId);

    if (more == null) {
      _more = res.list;
    } else {
      _more!.addAll(res.list);
    }

    if (res.list.isEmpty && _currentPage > 0) {
      _currentPage--;
    }

    if (!loadMore) {
      _total = res.total;
    }
    notifyListeners();
    return res.total;
  }
}
