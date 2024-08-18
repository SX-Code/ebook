import 'package:e_book_clone/components/web/define_webview.dart';
import 'package:e_book_clone/style/ebook_reader_js.dart';
import 'package:e_book_clone/utils/log_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ReaderWebview extends StatefulWidget {
  const ReaderWebview({
    super.key,
    required this.webViewType,
    required this.loadResource,
    this.defalutThemeStyle,
    this.jsChannelMap,
    this.onWebViewCreated,
    this.clearCache,
    this.injectDefaultCssCallback,
  });

  // 需要加载的内容类型
  final WebViewType? webViewType;

  // web view加载的数据，url 或者 html
  final String loadResource;

  final Map<String, JsChannelCallback>? jsChannelMap;

  final bool? clearCache;

  final String? defalutThemeStyle;

  final Function(InAppWebViewController controller)? onWebViewCreated;
  final VoidCallback? injectDefaultCssCallback;

  @override
  State<ReaderWebview> createState() => _ReaderWebviewState();
}

class _ReaderWebviewState extends State<ReaderWebview> {
  // web view 控制器
  late InAppWebViewController webViewController;
  final GlobalKey webViewKey = GlobalKey();
  bool isInjectJs = false;
  bool isInjectCss = false;

  late EbookReaderJsCss ebookReaderJsCss;

  // web view配置
  InAppWebViewSettings settings = InAppWebViewSettings(
    // 跨平台配置
    transparentBackground: true,
    useShouldInterceptRequest: true,
    // useShouldOverrideUrlLoading: true, // 会导致IOS白屏
    mediaPlaybackRequiresUserGesture: false,
    builtInZoomControls: false,
    // 不允许缩放
    useHybridComposition: true,
    // 支持HybridComposition
    // IOS 平台配置
    allowsInlineMediaPlayback: false,
    allowBackgroundAudioPlaying: false,
  );

  @override
  void initState() {
    super.initState();
    ebookReaderJsCss = EbookReaderJsCss.instance();
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
        // if (progress >= 40 && !isInjectCss) {
        //   isInjectCss = true;
        // }
        if (progress >= 87 && !isInjectJs) {
          controller.evaluateJavascript(source: ebookReaderJsCss.jsEvent);
          isInjectJs = true;
        }
      },
      onLoadStart: (InAppWebViewController controller, WebUri? url) {
        isInjectJs = false;
        isInjectCss = false;
        // ToastUtils.showLoading(duration: const Duration(seconds: 10));
      },
      onReceivedError: (InAppWebViewController controller,
          WebResourceRequest request, WebResourceError error) {
        // ToastUtils.dismissAllToast();
      },
      onLoadStop: (InAppWebViewController controller, WebUri? url) async {},
      onTitleChanged: (controller, title) async {},
      onPageCommitVisible: (InAppWebViewController controller, WebUri? url) {
        controller.injectCSSCode(
            source: ebookReaderJsCss.customThemeCSS +
                ebookReaderJsCss.customStyleCss);
        widget.injectDefaultCssCallback?.call();
      },
    );
  }
}
