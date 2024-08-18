import 'package:e_book_clone/json/store_json.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:flutter/material.dart';

class FavouriteViewModel with ChangeNotifier {
  List<Book>? _recommend;

  List<Book>? get recommend => _recommend;

  set recommend(List<Book>? recommend) {
    _recommend = recommend;
    notifyListeners();
  }

  Future getRecommend() async {
    recommend = recommendationsList.map((item) {
      return Book(
        cover: item['img'] as String, 
        price: double.parse(item['price']), 
        title: item['title'] as String, 
        subTitle: item['sub_title'] as String, 
        authorName: item['author_name'] as String, 
        rate: item['rate'] as double, 
        favourite: item['favourite'] as bool, 
        page: int.parse(item['page']), 
      );
    }).toList();
  }
}
