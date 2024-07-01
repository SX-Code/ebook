class Book {
  Book({
    this.id,
    this.cover,
    this.title,
    this.subTitle,
    this.authorName,
    this.rate,
    this.price,
  });

  String? id;
  String? cover;
  String? title;
  String? subTitle;
  String? authorName;
  double? rate; // 评分
  double? price; // 价格
}
