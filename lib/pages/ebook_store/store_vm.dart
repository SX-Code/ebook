import 'dart:async';
import 'package:e_book_clone/http/spider/sipder_api.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:e_book_clone/models/ebook_topic.dart';
import 'package:e_book_clone/models/types.dart';
import 'package:flutter/material.dart';

class StoreViewModel with ChangeNotifier {
  List<Book>? _recommend;
  List<Book>? _discount;
  List<Book>? _newEbook;
  List<EBookTopic>? _topics;
  List<Category>? _categories;

  List<Book>? get recommend => _recommend;
  List<Book>? get discount => _discount;
  List<Book>? get newEbook => _newEbook;
  List<Category>? get categories => _categories;
  List<EBookTopic>? get topics => _topics;

  set recommend(List<Book>? recommend) {
    _recommend = recommend;
    notifyListeners();
  }

  set discount(List<Book>? discount) {
    _discount = discount;
    notifyListeners();
  }

  set newEBook(List<Book>? newEbook) {
    _newEbook = newEbook;
    notifyListeners();
  }

  set topics(List<EBookTopic>? topics) {
    _topics = topics;
    notifyListeners();
  }

  set categories(List<Category>? categories) {
    if (categories != null) {
      sortCategory(categories);
    }
    _categories = categories;
    notifyListeners();
  }

  Future getStoreData() async {
    SipderApi.instance().fetchStoreData(
      recommendCallback: (List<Book> values) => recommend = values,
      categoryCallback: (List<Category> values) => categories = values,
    );
  }

  Future getDailyDiscount() async {
    discount = await SipderApi.instance().fetchStoreEBookTile(EBookType.discount);
  }

  Future getNew() async {
    newEBook = await SipderApi.instance().fetchStoreEBookTile(EBookType.newbook);
  }

  Future getTopics() async {
    topics = await SipderApi.instance().fetchStoreTopics();
  }

  void sortCategory(List<Category> categories) {
    int count = 0;
    for (var i = 0; i < categories.length; i++) {
      count += categories[i].name?.length ?? 0;
      if (count > 12) {
        int index = findCategory(categories, i+1);
        if (index != -1) {
          var tmp = categories[i];
          categories[i] = categories[index];
          categories[index] = tmp;
        }
        count = 0;
      }
    }
  }

  int findCategory(List<Category> categories, int start) {
    for (var i = start; i < categories.length; i++) {
      int len = categories[i].name?.length ?? 0;
      if (len  == 2) {
        return i;
      }
    }
    return -1;
  }
}
