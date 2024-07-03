import 'package:e_book_demo/http/spider/spider_api.dart';
import 'package:e_book_demo/model/author.dart';
import 'package:e_book_demo/model/book.dart';
import 'package:e_book_demo/model/review.dart';
import 'package:flutter/material.dart';

class BookDetailViewModel extends ChangeNotifier {
  Book? _book;
  List<Author>? _authors;
  List<Review>? _reviews;
  List<Book>? _similiarBooks;

  Book? get book => _book;
  List<Author>? get authors => _authors;
  List<Review>? get reviews => _reviews;
  List<Book>? get similiarBooks => _similiarBooks;

  set book(Book? book) {
    _book = book;
    notifyListeners();
  }

  set authors(List<Author>? authors) {
    _authors = authors;
    notifyListeners();
  }

  set reviews(List<Review>? reviews) {
    _reviews = reviews;
    notifyListeners();
  }

  set similiarBooks(List<Book>? similiarBooks) {
    _similiarBooks = similiarBooks;
    notifyListeners();
  }

  Future getBookDetail(Book value) async {
    SpiderApi.instance().fetchBookDetail(
      value,
      bookCallback: (Book value) => book = value,
      authorCallback: (List<Author> values) => authors = values,
      reviewCallback: (List<Review> values) => reviews = values,
      similiarBooksCallback: (List<Book> values) => similiarBooks = values,
    );
  }
}
