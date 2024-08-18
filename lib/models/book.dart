import 'package:e_book_clone/http/spider/api_string.dart';

class Book {
  Book(
      {this.id,
      this.cover,
      this.price,
      this.title,
      this.authorName,
      this.subTitle,
      this.rate,
      this.favourite = false,
      this.page,
      this.read,
      this.description,
      this.labelCount,
      this.buyInfo,
      this.progress,
      this.kind,
      this.tags});

  Book.fromDoubanJson(dynamic json) {
    // 解析用户名
    List authors = json['author'];
    if (authors.isEmpty) {
      authors = json['origAuthor'];
      if (authors.isEmpty) {
        authors = json['translator'];
      }
    }
    if (authors.isNotEmpty) {
      authorName = authors[0]['name'];
    }
    id = json['id'];
    cover = json['cover'];
    labelCount = json['wordCount'].toString();
    title = json['title'];
    description = json['abstract'] as String;
    if (description != null && description!.length < 10) {
      subTitle = description?.substring(0, description!.length);
    } else {
      subTitle = description?.substring(0, 10);
    }
    
    int? priceInt = json['salesPrice'] ?? json['fixedPrice'];
    if (priceInt != null && priceInt != 0) {
      String priceStr = priceInt.toString();
      priceStr =
          '${priceStr.substring(0, priceStr.length - 2)}.${priceStr.substring(priceStr.length - 2)}';
      price = double.parse(priceStr);
    }
  }

  Book.fromBookshelf(dynamic json, int this.progress) {
    List authors = json['author'];
    if (authors.isEmpty) {
      authors = json['origAuthor'];
      if (authors.isEmpty) {
        authors = json['translator'];
      }
    }
    if (authors.isNotEmpty) {
      authorName = authors[0]['name'];
    }
    id = json['id'];
    cover = json['cover'];
    labelCount = json['wordCount'].toString();
    title = json['title'];
  }

  Book.fromSimilar(dynamic json) {
    List authors = json['author'];
    if (authors.isEmpty) {
      authors = json['origAuthor'];
      if (authors.isEmpty) {
        authors = json['translator'];
      }
    }
    id = ApiString.getId(json['url'], ApiString.ebookIdRegExp);
    cover = json['cover'];
    title = json['title'];
    int? priceInt = json['realPrice']['price'];
    if (priceInt != null && priceInt != 0) {
      String priceStr = priceInt.toString();
      priceStr =
          '${priceStr.substring(0, priceStr.length - 2)}.${priceStr.substring(priceStr.length - 2)}';
      price = double.parse(priceStr);
    }
  }

  Map<String, dynamic> toDatabaseJson() {
    return {
      "id": id,
      "cover": cover,
      "price": price,
      "title": title,
      "authorName": authorName,
      "subTitle": subTitle,
      "rate": rate,
      "page": page,
      "read": read,
      "kind": kind,
    };
  }

  String? id;
  String? cover;
  double? price;
  String? title;
  String? authorName;
  String? subTitle;
  double? rate;
  bool? favourite;
  int? page;
  int? read;
  String? kind;
  int? progress;
  String? labelCount;
  String? description;
  List<BuyInfo>? buyInfo;
  List<Tag>? tags;
}

/// 电子书额外信息
class EBookExtra {
  EBookExtra(
      {this.isReadable,
      this.hasOwned,
      this.isOnSale,
      this.salesPrice,
      this.isOnShelf});

  bool? isReadable; // 是否支持免费试读
  bool? hasOwned; // 是否作者
  bool? salesPrice; // 售价，0表示免费
  bool? isOnSale; // 在售
  bool? isOnShelf; // 是否在书架
}

class BuyInfo {
  BuyInfo({this.name, this.price, this.url});

  String? name;
  double? price;
  String? url;
}

class Tag {
  Tag({this.name, this.count, this.url});

  String? name;
  String? count;
  String? url;
}

class Category {
  Category({this.name, this.url});

  String? name;
  String? url;
}
