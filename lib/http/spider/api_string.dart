class ApiString {
  // 每日一言接口地址
  static const String dailyPoetry = "https://v1.jinrishici.com/all.json";

  // 豆瓣读书首页地址
  static const String baseUrl = "https://book.douban.com/";
  static const String bookDetailUrl = "https://book.douban.com/subject/";
  static const String userUrl = "https://book.douban.com/author/";
  static const String activitiesUrl = "https://book.douban.com/j/home/activities";
  static const String bookExpressUrl = "https://book.douban.com/j/home/express_books";
  static const String bookTop250Url = "https://book.douban.com/top250"; // ?start=0
  static const String bookMoreExpressBookUrl = "https://book.douban.com/latest/"; // ?subcat=文学
  static const String bookMoreWeeklyBookUrl = "https://book.douban.com/chart/"; // ?subcat=art

  // 豆瓣阅读
  static const String ebookBaseUrl = "https://read.douban.com";
  static const String ebooksUrl = "https://read.douban.com/ebooks/";
  static const String ebookDetailUrl = "https://read.douban.com/ebook/";
  static const String ebookBaseJsonUrl = "https://read.douban.com/j/ebooks/";
  static const String ebookReviewUrl = "https://read.douban.com/j/ebook/";
  static const String ebookDiscountUrl = "$ebookBaseJsonUrl/top_sections_promotion_ebooks";
  static const String ebookNewUrl = "$ebookBaseJsonUrl/top_sections_new_express_ebooks";
  static const String ebookTopicsSection = "$ebookBaseJsonUrl/topics_sections";
  static const String ebookMoreJsonUrl = "https://read.douban.com/j/kind/";
  static const String ebookMoreUrl = "$ebookBaseUrl/category/1?sort=hot&page=1";
  static const String ebookTopicJsonUrl = "https://read.douban.com/j/topic/#/works_list";
  static const String ebookTopicUrl = "$ebookBaseUrl/topic/";
  static const String ebookMineUrl = "$ebookBaseUrl/mine/";
  static const String ebookUserInfoJsonUrl = "https://read.douban.com/j/mine_v2/";
  static const String ebookLoginUrl = "$ebookBaseUrl/accounts/passport/login?source=ark&redir=https%3A%2F%2Fread.douban.com%2Fmine%2F";
  static const String ebookGraphqlUrl = "https://read.douban.com/j/graphql";
  static const String ebookSearchSuggestJsonUrl = "https://read.douban.com/j/suggest_v3";
  static const String ebookSearchJsonUrl = "https://read.douban.com/j/search_v2";

  static const String bookIdRegExp = r'(?<=/subject/)\d+(?=/)';
  static const String ebookIdRegExp = r'(?<=/ebook/)\d+(?=/)';
  static const String ebookTopicIdRegExp = r'(?<=/topic/)\d+(?=/)';
  static const String ebookLabelCount = r'(?<=字数约 ).*(?= 字)';
  static const String authorIdRegExp = r'(?<=/subject/)\d+(?=/)';
  static const String bookPageRegExp = r'(?<=页数:)\s{1,}\d{2,}';
  static const String bookPriceRegExp = r'(?<=定价:).*';
  static const String bookSubTitleRegExp = r'(?<=副标题:)\s{1,}[\u4e00-\u9fa5]*';
  static const String bookActivitiedBg = r"https:.*(?='\))";

  static String getBookActivitiesBg(String? str) {
    if (str == null || str.isEmpty) return "";
    return RegExp(bookActivitiedBg).stringMatch(str) ?? "";
  }

  static String getId(String? str, String exp) {
    if (str == null || str.isEmpty) return "";
    return RegExp(exp).stringMatch(str) ?? "";
  }
  
  static int getBookPage(String? str) {
    if (str == null || str.isEmpty) return 0;
    var res = RegExp(ApiString.bookPageRegExp).stringMatch(str);
    if (res == null || res.isEmpty) return 0;
    return int.parse(res);
  }

  static double getBookPrice(String? str) {
    if (str == null || str.isEmpty) return 0;
    var res = RegExp(ApiString.bookPriceRegExp).stringMatch(str);
    if (res == null || res.isEmpty) return 0;
    res = res.replaceFirst('元', '');
    return double.parse(res);
  }

  static String getSubTitle(String? str) {
    if (str == null || str.isEmpty) return "";
    return RegExp(ApiString.bookSubTitleRegExp).stringMatch(str)?.trim() ?? "";
  }

  static String getLabelCount(String? str) {
    if (str == null || str.isEmpty) return "";
    return RegExp(ApiString.ebookLabelCount).stringMatch(str)?.trim() ?? "";
  }

  static String getTopicId(String? str) {
    if (str == null || str.isEmpty) return "";
    return RegExp(ApiString.ebookTopicIdRegExp).stringMatch(str)?.trim() ?? "";
  }


}
