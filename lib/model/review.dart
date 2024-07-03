import 'package:e_book_demo/model/author.dart';

class Review {
  Review({
    this.id,
    this.author,
    this.date,
    this.rate,
    this.short,
    this.url,
  });

  String? id;
  Author? author;
  double? rate; // 评分
  String? short; // 短评
  String? date; // 日期
  String? url; 
  
}