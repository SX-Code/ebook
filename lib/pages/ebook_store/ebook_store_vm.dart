import 'package:e_book_demo/http/spider/spider_api.dart';
import 'package:e_book_demo/model/book.dart';
import 'package:e_book_demo/model/ebook_category.dart';
import 'package:flutter/material.dart';

class EbookStoreViewModel extends ChangeNotifier {
  List<Book>? _recommend;
  List<EBookCategory>? _categories;

  List<Book>? get recommend => _recommend;
  List<EBookCategory>? get categories => _categories;

  set recommend(List<Book>? recommend) {
    _recommend = recommend;
    notifyListeners();
  }

  set categories(List<EBookCategory>? categories) {
    if (categories != null) {
      sortCategory(categories);
    }
    _categories = categories;
    notifyListeners();
  }

  Future getEBookStoreData() async {
    SpiderApi.instance().fetchEBookStoreData(
      recommendCallback: (List<Book> values) => recommend = values,
      categoriesCallback: (List<EBookCategory> values) => categories = values,
    );
  }

  // 排序
  void sortCategory(List<EBookCategory> categories) {
    int count = 0;
    for (int i = 0; i< categories.length; i++) {
      count += categories[i].name?.length ?? 0;
      if (count > 12) {
        // 找一个长度短的
        int index = findCategory(categories, i+1);
        if (index != -1) {
          // 交换
          var tmp = categories[i];
          categories[i] = categories[index];
          categories[index] = tmp;
        }
        count = 0;
      }
    }
  } 

  // 找一个长度为2的分类
  int findCategory(List<EBookCategory> categories, int start) {
    for (int i = start; i< categories.length; i++) {
     int len = categories[i].name?.length ?? 0;
     if (len == 2) {
      return i;
     }
    }
    return -1;
  }
}
