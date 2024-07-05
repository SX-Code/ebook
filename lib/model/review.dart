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

  static const rateMap = {
    "很差": 2.0,
    "较差": 4.0,
    "还行": 6.0,
    "推荐": 8.0,
    "力荐": 10.0,
  };

  static double? getRate(String? attribut) {
    if (attribut == null || attribut.isEmpty) return 0.0;
    return rateMap[attribut];
  } 
  
}