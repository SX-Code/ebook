import 'package:e_book_clone/components/web/define_webview.dart';
import 'package:e_book_clone/http/dio_instance.dart';
import 'package:e_book_clone/http/spider/api_string.dart';
import 'package:e_book_clone/http/spider/json_api.dart';
import 'package:e_book_clone/models/types.dart';
import 'package:e_book_clone/models/user_info.dart';
import 'package:e_book_clone/user/user_provider.dart';
import 'package:e_book_clone/utils/constants.dart';
import 'package:e_book_clone/utils/log_utils.dart';
import 'package:e_book_clone/utils/shared_prefs_utils.dart';
import 'package:e_book_clone/utils/toast_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

class WebViewWidget extends StatefulWidget {
  const WebViewWidget({
    super.key,
    required this.webViewType,
    required this.loadResource,
    this.jsChannelMap,
    this.onWebViewCreated,
    this.clearCache,
    this.aim,
    this.onVisiableCallback,
  });

  // 需要加载的内容类型
  final WebViewType? webViewType;

  // web view加载的数据，url 或者 html
  final String loadResource;

  final Map<String, JsChannelCallback>? jsChannelMap;

  final bool? clearCache;

  final WebViewAim? aim;

  final VoidCallback? onVisiableCallback;

  final Function(InAppWebViewController controller)? onWebViewCreated;

  @override
  State<WebViewWidget> createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  // web view 控制器
  late InAppWebViewController webViewController;
  final GlobalKey webViewKey = GlobalKey();
  bool isInject = false;

  // web view配置
  InAppWebViewSettings settings = InAppWebViewSettings(
    // 跨平台配置
    transparentBackground: true,
    // useShouldOverrideUrlLoading: true, // 会导致IOS白屏
    mediaPlaybackRequiresUserGesture: false,
    builtInZoomControls: false,
    // 不允许缩放
    useHybridComposition: true,
    // 支持HybridComposition
    // IOS 平台配置
    allowsInlineMediaPlayback: true,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // ToastUtils.dismissAllToast();
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      key: webViewKey,
      initialSettings: settings,
      onWebViewCreated: (controller) {
        // web view初始化完成之后加载数据
        webViewController = controller;
        // 是否清楚缓存后再加载
        if (widget.clearCache == true) {
          InAppWebViewController.clearAllCache();
        }

        if (widget.onWebViewCreated == null) {
          if (widget.webViewType == WebViewType.htmlText) {
            webViewController.loadData(data: widget.loadResource);
          } else if (widget.webViewType == WebViewType.url) {
            webViewController.loadUrl(
                urlRequest: URLRequest(url: WebUri(widget.loadResource)));
          }
        } else {
          widget.onWebViewCreated?.call(controller);
        }

        // 注册与js通信回调
        widget.jsChannelMap?.forEach((handlerName, callback) {
          webViewController.addJavaScriptHandler(
              handlerName: handlerName, callback: callback);
        });
      },
      onConsoleMessage: (controller, consoleMessage) {
        // 这里打印来自js的console.log的输出
        LogUtils.logger("consoleMessage ==== 来自于js的打印==== \n $consoleMessage");
      },
      onProgressChanged: (InAppWebViewController controller, int progress) {
        if (!isInject && progress >= 10) {
          widget.onVisiableCallback?.call();
          isInject = true;
        }
      },
      onLoadStart: (InAppWebViewController controller, WebUri? url) {
        // ToastUtils.showLoading(duration: const Duration(seconds: 10));
        isInject = false;
      },
      onReceivedError: (InAppWebViewController controller,
          WebResourceRequest request, WebResourceError error) {
        // ToastUtils.dismissAllToast();
      },
      onLoadStop: (InAppWebViewController controller, WebUri? url) async {},
      onTitleChanged: (controller, title) async {
        if (title == '我的 | 豆瓣阅读' && widget.aim == WebViewAim.login) {
          // getCookie(controller);
          CookieManager.instance()
              .getCookies(url: WebUri(ApiString.ebookUserInfoJsonUrl))
              .then((List<Cookie> cookies) {
            setCookie(cookies).then((UserInfo userInfo) {
              Provider.of<UserProvider>(context, listen: false)
                  .setUserInfo(userInfo);
              Navigator.pop(context);
              ToastUtils.showSuccessMsg('登录成功');
            });
          });
        }
      },
      onPageCommitVisible: (InAppWebViewController controller, WebUri? url) {
        widget.onVisiableCallback?.call();
      },
    );
  }

  String getCookieScript() {
    return '''
      // var info = document.querySelector('.user-info')
      // while (info == null) {
      //   info = document.querySelector('.user-info')
      // }
      // var httpRequest = new XMLHttpRequest();
      // httpRequest.open('GET', 'https://read.douban.com/j/mine_v2/', true);
      // httpRequest.send();
      // httpRequest.onreadystatechange = function () {
      //     if (httpRequest.readyState == 4 && httpRequest.status == 200) {
      //         var json = httpRequest.responseText;
      //         console.log(httpRequest.);
      //     }
      // };
      return document.cookie;
    ''';
  }

  Future<UserInfo> setCookie(List<Cookie> cookies) async {
    StringBuffer buf = StringBuffer();
    for (Cookie cookie in cookies) {
      buf.write(cookie.name);
      buf.write("=");
      buf.write(cookie.value);
      buf.write(";");
    }
    String cookie = buf.toString();
    // 保存 cookie
    DioInstance.instance().cookie = cookie;
    UserInfo userInfo = await JsonApi.instance().fetchUsedrInfo();
    SharedPrefsUtils.putObject(Constants.keyUserInfo, userInfo);
    return userInfo;
  }
}
