import 'package:e_book_demo/model/book.dart';
import 'package:flutter/material.dart';

class BookDetailViewModel extends ChangeNotifier {
  Book? _book;
  String? _content;
  List? _authors;
  List? _reviews;
  List<Book>? _similiarBooks;

  Book? get book => _book;
  String? get content => _content;
  List? get authors => _authors;
  List? get reviews => _reviews;
  List<Book>? get similiarBooks => _similiarBooks;

  set book(Book? book) {
    _book = book;
    notifyListeners();
  }

  set content(String? content) {
    _content = content;
    notifyListeners();
  }

  set authors(List? authors) {
    _authors = authors;
    notifyListeners();
  }

  set reviews(List? reviews) {
    _reviews = reviews;
    notifyListeners();
  }

  set similiarBooks(List<Book>? similiarBooks) {
    _similiarBooks = similiarBooks;
    notifyListeners();
  }
}
