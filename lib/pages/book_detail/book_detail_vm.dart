import 'package:e_book_clone/http/spider/sipder_api.dart';
import 'package:e_book_clone/models/author.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:e_book_clone/models/review.dart';
import 'package:flutter/material.dart';

class BookDetailViewModel with ChangeNotifier {
  bool _dispose = false;
  Book? _book;
  List<Review>? _reviews;
  List<Author>? _authors;
  List<Book>? _similarBooks;

  Book? get book => _book;
  List<Review>? get reviews => _reviews;
  List<Author>? get authors => _authors;
  List<Book>? get similarBooks => _similarBooks;
  
  set isDispose(bool dispose) {
    _dispose = dispose;
  }
  
  set book(Book? book) {
    _book = book;
    if (_dispose) return;
    notifyListeners();
  }

  set reviews(List<Review>? reviews) {
    _reviews = reviews;
    if (_dispose) return;
    notifyListeners();
  }

  set authors(List<Author>? authors) {
    _authors = authors;
    if (_dispose) return;
    notifyListeners();
  }

  set similarBooks(List<Book>? similarBooks) {
    _similarBooks = similarBooks;
    if (_dispose) return;
    notifyListeners();
  }

  Future initData(Book value) async {
    await SipderApi.instance().fetchBookDetail(
      value,
      bookCallback: (value) => (book = value),
      reviewsCallback: (values) => (reviews = values),
      authorsCallback: (values) => (authors = values),
      similarBooksCallback: (values) => (_similarBooks = values),
    );
  }
}
