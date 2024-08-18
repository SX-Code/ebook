import 'dart:async';

import 'package:e_book_clone/http/spider/sipder_api.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:flutter/material.dart';

class DoubanReadViewModel with ChangeNotifier {
  List<Book>? _expressBooks;
  List<Book>? _weeklyHotBooks;
  List<Book>? _top250Books;

  List<Book>? get expressBooks => _expressBooks;
  List<Book>? get weeklyHotBooks => _weeklyHotBooks;
  List<Book>? get top250Books => _top250Books;

  set expressBooks(List<Book>? expressBooks) {
    _expressBooks = expressBooks;
    notifyListeners();
  }

  set weeklyHotBooks(List<Book>? weeklyHotBooks) {
    _weeklyHotBooks = weeklyHotBooks;
    notifyListeners();
  }

  set top250Books(List<Book>? top250Books) {
    _top250Books = top250Books;
    notifyListeners();
  }

  Future getExpressBooks() async {
    
  }

  Future getDoubanReadDatas() async {
    // 获取JSON数据
    SipderApi.instance().fetchExpressBooks().then((values) {
      expressBooks = values;
    });
    // 获取页面数据
    SipderApi.instance().fetchDoubanReadBooks(
      weeklyBooksCallback: (List<Book> values) => weeklyHotBooks = values,
      top250BooksCallback: (List<Book> values) => top250Books = values,
    );
  }
}
