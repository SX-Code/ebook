import 'package:e_book_demo/model/book.dart';
import 'package:e_book_demo/pages/book_detail/book_detail_page.dart';
import 'package:flutter/material.dart';

class NavigatorUtils {
  /// 跳转到图书详情页面
  /// [book] 图书
  static void nav2BookDetailPage(BuildContext context, {required Book book}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailPage(book: book),
      ),
    );
  }
}
