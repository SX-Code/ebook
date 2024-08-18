import 'package:e_book_clone/components/web/define_webview.dart';
import 'package:e_book_clone/components/web/webview_widget.dart';
import 'package:e_book_clone/models/types.dart';
import 'package:e_book_clone/style/ebook_reader_js.dart';
import 'package:e_book_clone/theme/theme_provider.dart';
import 'package:e_book_clone/utils/navigator_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

typedef WebsiteClickCallback = Function(String? title, String? link);

class WebViewPage extends StatefulWidget {
  const WebViewPage(
      {super.key,
      this.showTitle,
      this.title,
      required this.webViewType,
      required this.loadResource,
      this.jsChannelMap,
      this.aim});

  // 是否显示标题
  final bool? showTitle;

  final WebViewAim? aim;
  // 标题
  final String? title;

  // 需要加载的内容类型
  final WebViewType webViewType;

  // web view加载的数据，url 或者 html
  final String loadResource;

  final Map<String, JsChannelCallback>? jsChannelMap;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? _webViewController;

  @override
  void dispose() {
    super.dispose();
    // 隐藏软键盘
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark;
    if (Provider.of<ThemeProvider>(context, listen: false).isSystemTheme) {
      isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    } else {
      isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: _getAppBar(),
      ),
      body: WebViewWidget(
        aim: widget.aim,
        webViewType: widget.webViewType,
        loadResource: widget.loadResource,
        jsChannelMap: widget.jsChannelMap,
        onWebViewCreated: (controller) {
          controller.loadUrl(
              urlRequest: URLRequest(url: WebUri(widget.loadResource)));
          _webViewController = controller;
        },
        onVisiableCallback: () {
          // 加入书架
          if (widget.aim == WebViewAim.joinShelf) {
            // 样式
            _webViewController?.injectCSSCode(
              source: EbookReaderJsCss.instance().getEbookDetailCss(isDark),
            );
          }
        },
      ),
    );
  }

  _getAppBar() {
    return AppBar(
      title: Text(
        widget.showTitle == true ? widget.title ?? "" : "",
        style: TextStyle(
          fontSize: 18.sp,
        ),
      ),
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios_new,
          size: 20.r,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            NavigatorUtils.openInOuterBrowser(widget.loadResource);
          },
          tooltip: '在浏览器中打开',
          icon: const Icon(LineIcons.chrome),
        )
      ],
    );
  }

  String limitsStr(String? content, {int limit = 15}) {
    if (content == null || content.isEmpty == true) {
      return "";
    }
    if (content.length > 15) {
      return content.substring(0, 15);
    } else {
      return content;
    }
  }
}
