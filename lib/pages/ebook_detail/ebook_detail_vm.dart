import 'package:e_book_clone/http/spider/json_api.dart';
import 'package:e_book_clone/http/spider/sipder_api.dart';
import 'package:e_book_clone/models/author.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:e_book_clone/models/review.dart';
import 'package:flutter/material.dart';

class EBookDetailViewModel with ChangeNotifier {
  Book? _book;
  List<Review>? _reviews;
  List<Author>? _authors;
  List<Book>? _recommendEBooks;

  Book? get book => _book;
  List<Review>? get reviews => _reviews;
  List<Author>? get authors => _authors;
  List<Book>? get recommendEBooks => _recommendEBooks;

  set book(Book? book) {
    _book = book;
    notifyListeners();
  }

  set reviews(List<Review>? reviews) {
    _reviews = reviews;
    notifyListeners();
  }

  set authors(List<Author>? authors) {
    _authors = authors;
    notifyListeners();
  }

  set recommendEBooks(List<Book>? recommendEBooks) {
    _recommendEBooks = recommendEBooks;
    notifyListeners();
  }


  Future getSimilarEBooks(String bookId) async {
    recommendEBooks = await JsonApi.instance().fetchSimilarEbooks(bookId);
  }

  Future getEBookData(Book value) async {
    SipderApi.instance().fetchEBookDetail(
      value,
      ebookCallback: (Book value) => (book = value),
      reviewsCallback: (List<Review> values) => (reviews = values),
    ).then((_) {
      // 加载相似书籍
      getSimilarEBooks(value.id!);
    });
  }

  Future getEBookReviews(String id) async {
    reviews = await SipderApi.instance().fetchEbookReview(id);
  }
}