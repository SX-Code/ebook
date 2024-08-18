import 'package:e_book_clone/models/book.dart';

class EBookTopic {
  EBookTopic({
    required this.title,
    required this.ebooks,
    this.topicId,
    this.total,
  });

  String title;
  String? topicId;
  int? total;
  List<Book> ebooks;
}
