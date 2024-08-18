class MyDateUtils {
  static String getHello() {
    int hour = DateTime.now().hour;
    String tmp;
    if (hour <= 10) {
      tmp = "早上好";
    } else if (hour > 10 && hour <= 1) {
      tmp = "中午好";
    } else if (hour > 13 && hour <= 16) {
      tmp = "下午好";
    } else if (hour > 16 && hour <= 20) {
      tmp = "傍晚好";
    } else {
      tmp = "晚上好";
    }
    return tmp;
  }
}
