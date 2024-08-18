import 'package:e_book_clone/models/book.dart';
import 'package:e_book_clone/models/review.dart';

class BookDetail {
  BookDetail({
    this.book,
    this.comment,
  });

  Book? book;
  List<Review>? comment;
}
