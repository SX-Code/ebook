class ApiString {
  static const String bookDetailUrl = "https://book.douban.com/subject/";
  static const String bookActivitiesJsonUrl =
      "https://book.douban.com/j/home/activities";
  static const String bookExpressJsonUrl =
      "https://book.douban.com/j/home/express_books";
  static const String bookDoubanHomeUrl = "https://book.douban.com";
  static const String bookActivityCoverReg = r"https:.*(?='\))"; // 获取背景图片
  static const String bookIdRegExp = r'(?<=/subject/)\d+(?=/)'; // 获取书籍ID
  static const String bookPageRegExp = r'(?<=页数:)\s{1,}\d{2,}'; // 书籍页码
  static const String bookPriceRegExp = r'(?<=定价:).*';
  static String authorIdRegExp = r'(?<=/author/)\d+(?=/)'; 

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
}
