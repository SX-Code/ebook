class ApiString {
  static const String bookDetailUrl = "https://book.douban.com/subject/";
  static const String bookActivitiesJsonUrl =
      "https://book.douban.com/j/home/activities";
  static const String bookExpressJsonUrl =
      "https://book.douban.com/j/home/express_books";
  static const String bookDoubanHomeUrl = "https://book.douban.com";
  static const String ebookUrl = "https://read.douban.com/ebooks/"; 
  static const String bookActivityCoverReg = r"https:.*(?='\))"; // 获取背景图片
  static const String bookIdRegExp = r'(?<=/subject/)\d+(?=/)'; // 获取书籍ID
  static const String ebookIdRegExp = r'(?<=/bundle/)\d+(?=/)'; // 获取电子书籍ID
  static const String ebookCategoryIdRegExp = r'(?<=/category/)\d+'; // 电子书分类ID
  static const String bookPageRegExp = r'(?<=页数:)\s{1,}\d{2,}'; // 书籍页码
  static const String bookPriceRegExp = r'(?<=定价:).*';
  static const String ebookPriceRegExp = r'\d+.\d+(?=元立减)';
  static String authorIdRegExp = r'(?<=/author/)\d+(?=/)';

  static const String ebookDiscountJsonUrl = "https://read.douban.com/j/ebooks/top_sections_promotion_ebooks";
  static const String ebookNewPressJsonUrl = "https://read.douban.com/j/ebooks/top_sections_new_express_ebooks";



  static String getBookActivityCover(String? style) {
    if (style == null || style.isEmpty) return "";
    // 使用正则表达式获取背景图片
    return RegExp(bookActivityCoverReg).stringMatch(style) ?? "";
  }

  static String getId(String? content, String reg) {
    if (content == null || content.isEmpty) return "";
    return RegExp(reg).stringMatch(content) ?? "";
  }

  static int getBookPage(String? text) {
    if (text == null || text.isEmpty) return 0;
    var res = RegExp(ApiString.bookPageRegExp).stringMatch(text);
    if (res == null || res.isEmpty) return 0;
    return int.parse(res);
  }

  static double? getBookPrice(String? text) {
    if (text == null || text.isEmpty) return 0.0;
    var res = RegExp(ApiString.bookPriceRegExp).stringMatch(text);
    if (res == null || res.isEmpty) return 0;
    res = res.replaceFirst("元", '');
    return double.parse(res);
  }

  /// 获取立减价格
  static double getEBookDiscountOrder(String? text) {
    if (text == null || text.isEmpty) return 0.0;
    String res = RegExp(ApiString.ebookPriceRegExp).stringMatch(text) ?? "0.0";
    return double.parse(res);
  }
}
