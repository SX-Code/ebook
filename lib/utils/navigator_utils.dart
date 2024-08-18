import 'package:e_book_clone/components/web/define_webview.dart';
import 'package:e_book_clone/components/web/webview_page.dart';
import 'package:e_book_clone/http/spider/api_string.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:e_book_clone/models/types.dart';
import 'package:e_book_clone/pages/book_detail/book_detail_page.dart';
import 'package:e_book_clone/pages/book_more_tab/book_more_tab_page.dart';
import 'package:e_book_clone/pages/bookshelf/ebookshelf_page.dart';
import 'package:e_book_clone/pages/ebook_detail/ebook_detail_page.dart';
import 'package:e_book_clone/pages/ebook_more_tab/ebook_more_tab_page.dart';
import 'package:e_book_clone/pages/reader/reader_page.dart';
import 'package:e_book_clone/pages/settings/settings_page.dart';
import 'package:e_book_clone/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

typedef NavigatorCallback = Function();

class NavigatorUtils {
  /// 跳转到登录页面
  /// [context]构建上下文
  static void nav2LoginPage(BuildContext context, {VoidCallback? callback}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WebViewPage(
          webViewType: WebViewType.url,
          loadResource: ApiString.ebookLoginUrl,
          title: '登录',
          showTitle: true,
          aim: WebViewAim.login,
        ),
      ),
    ).then((_) {
      callback?.call();
    });
  }

  /// 跳转到加入书架页面
  /// [context]构建上下文
  static void nav2JoinShelfPage(BuildContext context, String url,
      {VoidCallback? callback}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(
          webViewType: WebViewType.url,
          loadResource: url,
          title: '加入书架',
          showTitle: true,
          aim: WebViewAim.joinShelf,
        ),
      ),
    ).then((_) {
      callback?.call();
    });
  }

  /// 跳转到WebView页面
  /// [context]构建上下文
  /// [url] 网页链接
  static void nav2WebView(BuildContext context, String url, {String? title}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(
          webViewType: WebViewType.url,
          loadResource: url,
          title: title,
        ),
      ),
    );
  }

  /// 跳转到阅读页面
  /// [context]构建上下文
  /// [bookId] 书籍ID
  static void nav2ReaderPage(BuildContext context, String bookId,
      {NavigatorCallback? callback}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReaderPage(
          webViewType: WebViewType.url,
          loadResource:
              'https://read.douban.com/reader/ebook/$bookId/?dcs=ebook',
        ),
      ),
    ).then((value) {
      callback?.call();
    });
  }

  /// 跳转到书籍详情页
  /// [context] 构建上下文
  /// [type] 详情页面类型，图书 or 电子书
  /// [book] 参数
  static void nav2Detail(BuildContext context, DetailPageType type, Book book) {
    if (book.id == null || book.id!.isEmpty) return;
    if (type == DetailPageType.book) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => BookDetailPage(book: book)));
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => EBookDetailPage(book: book)));
    }
  }

  /// 跳转到更多电子书页面
  /// [context]构建上下文
  /// [url] 网页链接
  static void nav2EBookMorePage(BuildContext context, String title,
      {EBookSort sort = EBookSort.hottest,
      bool isPromotion = false,
      MorePageType pageType = MorePageType.category,
      EBookKind kind = EBookKind.all,
      String? topicId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EbookMoreTabPage(
          title: title,
          sort: sort,
          isPromotion: isPromotion,
          pageType: pageType,
          kind: kind,
          topicId: topicId,
        ),
      ),
    );
  }

  static void nav2BookMorePage(
      BuildContext context, String title, MorePageType pageType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (conetxt) => BookMoreTabPage(
          title: title,
          pageType: pageType,
        ),
      ),
    );
  }

  static void nav2Settings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (conetxt) => const SettingsPage()),
    );
  }

  /// 打开外部浏览器
  static Future openInOuterBrowser(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ToastUtils.showErrorMsg('链接无法打开');
    }
  }

  static void nav2Bookshelf(BuildContext context, String? userId,
      {EBookProgressType? processType}) {
    if (userId == null || userId.isEmpty) {
      ToastUtils.showInfoMsg('请先登录');
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookshelfPage(
          progressType: processType,
        ),
      ),
    );
  }
}
