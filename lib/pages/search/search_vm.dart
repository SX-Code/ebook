import 'package:e_book_clone/http/spider/json_api.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:e_book_clone/models/query_param.dart';
import 'package:e_book_clone/models/suggest.dart';
import 'package:flutter/material.dart';

class SearchViewModel extends ChangeNotifier {
  int _currPage = 2;
  bool isDispose = false;
  List<Book>? _searchResult;

  List<Book>? get searchResult => _searchResult;

  Future<List<Suggest>> getSuggest(String keyword) async {
    if (keyword.isEmpty) {
      return [];
    }
    return await JsonApi.instance().fetchSuggestV3(keyword);
  }

  Future getResults(String keyword, bool loadMore, {VoidCallback? callback}) async {
    if (loadMore) {
      _currPage++;
    } else {
      _currPage = 1;
      _searchResult?.clear();
    }

    // 请求参数
    SearchParam param = SearchParam(
      page: _currPage,
      rootKind: null,
      q: keyword,
      sort: "defalut",
      query: SearchParam.ebookSearch,
    );
    // 请求结果
    List<Book> res = await JsonApi.instance().fetchEbookSearch(param);

    if (_searchResult == null) {
      _searchResult = res;
    } else {
      _searchResult!.addAll(res);
    }

    if (res.isEmpty && _currPage > 0) {
      _currPage--;
    }
    if (isDispose) return;
    notifyListeners();
    // return _searchResult ?? [];
  }
}
