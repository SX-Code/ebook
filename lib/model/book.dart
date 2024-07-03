
class Book {
  Book({
    this.id,
    this.cover,
    this.title,
    this.subTitle,
    this.authorName,
    this.rate,
    this.price,
    this.page,
    this.buyInfo,
    this.description,
    this.wordCount,
  });

  String? id;
  String? cover;
  String? title;
  String? wordCount; // 字数
  String? subTitle;
  String? authorName;
  double? rate; // 评分
  int? page; // 页码
  double? price; // 价格
  String? description; // 内容简介
  List<BuyInfo>? buyInfo;
}

class BuyInfo {
  BuyInfo({
    this.name,
    this.price,
    this.url,
  });

  String? name;
  double? price;
  String? url;
}
