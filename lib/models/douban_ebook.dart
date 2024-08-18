import 'package:e_book_clone/models/book.dart';

/// 解析豆瓣的JSON数据
class ResultDoubanList {
  ResultDoubanList({
    required this.total,
    required this.list,
  });

  ResultDoubanList.fromJson(dynamic json) : list = [], total = 0 {
    total = json['total'] ?? 0;
    list = [];
    if (json['list'] is List) {
      for (var v in json['list']) {
        list.add(Book.fromDoubanJson(v));
      }
    }
  }

  int total;
  List<Book> list;
}