import 'package:e_book_clone/http/spider/sipder_api.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:flutter/material.dart';

class BookMoreTabViewModel with ChangeNotifier {
  List<Book>? _expressBooks;
  int _currentPage = 0;

  List<Book>? get expressBooks => _expressBooks;

  Future getSubcatExpressBooks(
      String subcat, String path, bool loadMore) async {
    if (loadMore) {
      _currentPage++;
    } else {
      _currentPage = 0;
      _expressBooks?.clear();
    }

    List<Book> res = await SipderApi.instance()
        .fetchSubcatExpressBooks({"subcat": subcat, "p": _currentPage.toString()}, path);

    if (_expressBooks == null) {
      _expressBooks = res;
    } else {
      _expressBooks?.addAll(res);
    }

    if (res.isEmpty && _currentPage > 0) {
      _currentPage--;
    }

    notifyListeners();
  }
}
