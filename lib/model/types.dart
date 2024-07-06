import 'package:e_book_demo/http/spider/api_string.dart';

enum BookExpressTag {
  all('全部', '全部'),
  ;

  const BookExpressTag(this.name, this.value);
  final String name;
  final String value;
}

enum EBookType {
  recommend(".featured-books", ApiString.ebookUrl),
  discount(".discount-books", ApiString.ebookDiscountJsonUrl),
  newWorks(".new-works", ApiString.ebookNewPressJsonUrl),

  ;

  const EBookType(this.clz, this.api);

  final String clz;
  final String api;
}