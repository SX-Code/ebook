import 'package:e_book_clone/models/book.dart';
import 'package:e_book_clone/models/types.dart';

class EBookshelf {
  EBookshelf({
    required this.total,
    required this.books,
    this.progressType,
  });

  int total;
  EBookProgressType? progressType;
  List<Book> books;
}
