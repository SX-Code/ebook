class ApiString {

  static const String bookActivitiesJsonUrl = "https://book.douban.com/j/home/activities";
  static const String bookExpressJsonUrl = "https://book.douban.com/j/home/express_books";
  static const String bookDoubanHomeUrl = "https://book.douban.com";
  static const String bookActivityCoverReg = r"https:.*(?='\))"; // 获取背景图片
  static const String bookIdRegExp = r'(?<=/subject/)\d+(?=/)'; // 获取书籍ID

  static String getBookActivityCover(String? style) {
    if (style == null || style.isEmpty) return "";
    // 使用正则表达式获取背景图片
    return RegExp(bookActivityCoverReg).stringMatch(style)  ?? "";
  }

  static String getId(String? content, String reg) {
    if (content == null || content.isEmpty) return "";
    return RegExp(reg).stringMatch(content)  ?? "";
  }
}