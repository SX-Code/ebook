import 'package:e_book_clone/json/home_json.dart';
import 'package:e_book_clone/models/author.dart';

class Review {
  Review({this.id, this.author, this.rate, this.short, this.date, this.url});

  String? id;
  Author? author;
  double? rate;
  String? short;
  String? date;
  String? url;

  static const rateMap = {
    "很差": 2.0,
    "较差": 4.0,
    "还行": 6.0,
    "推荐": 8.0,
    "力荐": 10.0,
  };

  static double? getRage(String? str) {
    if (str == null || str.isEmpty) return 0;
    return rateMap[str];
  }

  static List<Review> initData() {
    return reviewsPeople.map((item) {
      return Review(
        author: Author(
          avatar: item['img'],
          name: item['name'],
        ),
        rate: item['rate'],
        short: item['text'],
      );
    }).toList();
  }
}
