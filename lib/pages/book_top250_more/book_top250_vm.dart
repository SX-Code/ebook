import 'package:e_book_clone/http/spider/sipder_api.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:flutter/material.dart';

class BookTop250ViewModel extends ChangeNotifier {
  List<Book>? _top250Books;
  int _currentPage = 0;

  List<Book>? get top250Books => _top250Books;

  Future getTop250Books(bool loadMore) async {
    if (loadMore) {
      _currentPage++;
    } else {
      _currentPage = 0;
      _top250Books?.clear();
    }
    List<Book> res = await SipderApi.instance().fetchTop250Books(_currentPage);
    
    if (_top250Books == null) {
      _top250Books = res;
    } else {
      _top250Books!.addAll(res);
    }


    if (res.isEmpty && _currentPage > 0) {
      _currentPage--;
    }
    
    notifyListeners();
  }
}
