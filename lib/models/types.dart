import 'package:e_book_clone/http/spider/api_string.dart';

enum WebViewAim { login, joinShelf }

enum EBookType {
  recommand(api: ApiString.ebooksUrl, clz: ".featured-books"),
  discount(api: ApiString.ebookDiscountUrl, clz: ".discount-books"),
  newbook(api: ApiString.ebookNewUrl, clz: ".new-works");

  const EBookType({required this.api, required this.clz});
  final String clz;
  final String api;
}

enum MorePageType {
  category("category", ApiString.ebookMoreJsonUrl, url: ApiString.ebookMoreUrl),
  topic("topic", ApiString.ebookTopicJsonUrl, url: ApiString.ebookTopicUrl),
  bookExpress("latest", ApiString.bookMoreExpressBookUrl),
  bookWeekly("chart", ApiString.bookMoreWeeklyBookUrl),
  ;

  const MorePageType(this.name, this.path, {this.url});
  final String name;
  final String path;
  final String? url;
}

enum BookExpressType {
  all("全部"),
  ;

  const BookExpressType(this.name);

  final String name;
}

enum DetailPageType { book, ebook }

/// 电子书类别
enum EBookKind {
  all('全部', 1),
  novel('小说', 100),
  literature('文学', 101),
  humanity('人文社区', 102),
  economy('经济管理', 103),
  technology('科技科普', 104),
  internet('计算机与互联网', 105),
  inspiring('成功励志', 106),
  live('生活', 107),
  children('少儿', 108),
  art('艺术设计', 109),
  comic('漫画绘本', 110),
  education('教育考试', 111),
  magazine('杂志', 2),
  ;

  const EBookKind(this.key, this.value);
  final int value;
  final String key;

  static List<String> names() {
    return EBookKind.values.map((value) {
      return value.key;
    }).toList();
  }
}

/// 电子书过滤排序类别
enum EBookSort {
  synthesis("综合", "default"),
  hottest('热度最高', "hot"),
  latest('新上架', "new"),
  priceasc('价格最低', "price_asc"),
  sales('销量最高', "sales"),
  rating('好评最多', "rating"),
  douban('豆瓣最高', "book_rating"),
  ;

  const EBookSort(this.key, this.value);
  final String key;
  final String value;
}

enum BookExpressSubcat {
  literary("全部", "全部"),
  hottest('文学', "文学"),
  novel('小说', "小说"),
  history('历史文化', "历史文化"),
  social('科学纪实', "科学纪实"),
  tech('科学新知', "科学新知"),
  art('艺术设计', "艺术设计"),
  drama('影视戏剧', "影视戏剧"),
  business('商业经营', "商业经营"),
  comics('绘本漫画', "绘本漫画"),
  ;

  const BookExpressSubcat(this.name, this.subcat);
  final String name;
  final String subcat;

  static List<String> names() {
    return BookExpressSubcat.values.map((value) {
      return value.name;
    }).toList();
  }

  static List<String> subcats() {
    return BookExpressSubcat.values.map((value) {
      return value.subcat;
    }).toList();
  }

  static String? getSubcat(String name) {
    return BookExpressSubcat.values
        .firstWhere((value) => value.name == name)
        .subcat;
  }
}

enum BookWeeklySubcat {
  literary("全部", "all"),
  hottest('文学', "literary"),
  novel('小说', "novel"),
  history('历史文化', "history"),
  social('科学纪实', "social"),
  tech('科学新知', "tech"),
  art('艺术设计', "art"),
  drama('影视戏剧', "drama"),
  business('商业经营', "business"),
  comics('绘本漫画', "comics"),
  suspenseNovel('悬疑推理', "suspense_novel"),
  scienceFiction('科幻奇幻', "science_fiction"),
  ;

  const BookWeeklySubcat(this.name, this.subcat);
  final String name;
  final String subcat;

  static List<String> names() {
    return BookWeeklySubcat.values.map((value) {
      return value.name;
    }).toList();
  }

  static List<String> subcats() {
    return BookWeeklySubcat.values.map((value) {
      return value.subcat;
    }).toList();
  }
}

/// 电子书进入
enum EBookProgressType {
  all("全部", null),
  never("0%", 'Never'),
  reading("1-99%", 'Reading'),
  finished("100%", 'Finished');

  const EBookProgressType(this.name, this.value);
  final String name;
  final String? value;

  static Map<String, String?> map() =>
      {for (var item in EBookProgressType.values) item.name: item.value};
}

enum EBookSerialStatus {
  all("全部", null),
  serialized("连载中", false),
  finalized("已完结", true),
  ;

  const EBookSerialStatus(this.name, this.value);
  final String name;
  final bool? value;

  static Map<String, bool?> map() =>
      {for (var item in EBookSerialStatus.values) item.name: item.value};
}

enum EBookHasOwned {
  all("全部", null),
  serialized("已购买", true),
  finalized("未购买", false),
  ;

  const EBookHasOwned(this.name, this.value);
  final String name;
  final bool? value;

  static Map<String, bool?> map() =>
      {for (var item in EBookHasOwned.values) item.name: item.value};
}

enum EBookUpdatedDays {
  all("全部", null),
  ten("10天内", "Ten"),
  thirty("30天内", "Thirty"),
  ;

  const EBookUpdatedDays(this.name, this.value);
  final String name;
  final String? value;

  static Map<String, String?> map() =>
      {for (var item in EBookUpdatedDays.values) item.name: item.value};
}
