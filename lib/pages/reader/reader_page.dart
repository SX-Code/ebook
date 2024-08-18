import 'package:e_book_clone/pages/reader/my_bottom_sheet_setting.dart';
import 'package:e_book_clone/components/web/define_webview.dart';
import 'package:e_book_clone/pages/reader/reader_vm.dart';
import 'package:e_book_clone/pages/reader/reader_webview.dart';
import 'package:e_book_clone/style/ebook_reader_js.dart';
import 'package:e_book_clone/theme/theme_provider.dart';
import 'package:e_book_clone/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';

class ReaderPage extends StatefulWidget {
  const ReaderPage(
      {super.key,
      this.showTitle,
      this.title,
      required this.webViewType,
      required this.loadResource});

  // 是否显示标题
  final bool? showTitle;

  // 标题
  final String? title;

  // 需要加载的内容类型
  final WebViewType webViewType;

  // web view加载的数据，url 或者 html
  final String loadResource;

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage>
    with SingleTickerProviderStateMixin {
  bool isShowBottomSheet = false;
  final _bottomSheetScaffoldKey = GlobalKey<ScaffoldState>();
  InAppWebViewController? _webViewController;
  late AnimationController _animationController;
  late Animation _animation;
  final ReaderViewModel _viewModel = ReaderViewModel();

  bool isShowComment = false;
  bool isShowTheme = false;
  bool isShowSetting = false;
  late ThemeProvider themeProvider;

  SettingSheetController settingSheetController = SettingSheetController();

  @override
  void initState() {
    _viewModel.init(Provider.of<ThemeProvider>(context, listen: false).isDarkMode);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear);

    _animation = Tween(begin: 0.0, end: 220.0).animate(_animationController);
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // 隐藏软键盘
    FocusManager.instance.primaryFocus?.unfocus();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReaderViewModel>(
      create: (context) => _viewModel,
      builder: (context, child) {
        return Consumer<ReaderViewModel>(builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: vm.currColor,
            key: _bottomSheetScaffoldKey,
            body: SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  ReaderWebview(
                    webViewType: widget.webViewType,
                    loadResource: widget.loadResource,
                    jsChannelMap: {
                      "toggleCommentCallback": _toggleCommentCallback,
                      "toggleThemeCallback": _toggleThemeCallback,
                      "toggleSettingsCallback": _toggleSettingsCallback,
                      "innerClickCallback": _innerClickCallback,
                      "showTocCallback": _showTocCallback,
                    },
                    injectDefaultCssCallback: () {
                      // bool isDark;
                      // if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
                      //   isDark = true;
                      // } else {
                      //   isDark = themeProvider.isDarkMode;
                      // }
                      // 执行注入CSS的JS代码
                      String source =
                          vm.generateDefaultThemStyle();
                      _webViewController?.injectCSSCode(source: source);
                    },
                    onWebViewCreated: (value) {
                      value.loadUrl(
                          urlRequest:
                              URLRequest(url: WebUri(widget.loadResource)));
                      _webViewController = value;
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 90.0),
                          height: _animation.value,
                          child: MyBottomSheetSetting(
                            controller: settingSheetController,
                            bgItemTap: (index, isToDark) {
                              _switchTheme(isToDark, index);
                            },
                            fontSizeTap: (fontSize, lineHeight) {
                              _setFontSize(fontSize, lineHeight);
                            },
                            brightnessSlid: (brightness) {
                              _setBrightness(brightness);
                            },
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
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

  // 显示评论
  void _toggleCommentCallback(List<dynamic> args) {
    closeBottomSheet();
    if (isShowComment) {
    } else {}
    isShowComment = !isShowComment;
  }

  // 显示目录回调
  void _showTocCallback(List<dynamic> args) {
    closeBottomSheet();
  }

  // 切换主题回调，JS交互代码
  void _toggleThemeCallback(List<dynamic> args) {
    if (themeProvider.isSystemTheme) {
      DialogUtils.showQuestionDialog(context,
          title: "切换主题", content: "主动切换主题后，跟随系统主题将被关闭。可在设置中重新开启", confirm: () {
        // 关闭跟随
        themeProvider.closeSystemTheme();
        // 切换主题
        bool is2Dark =
            MediaQuery.of(context).platformBrightness == Brightness.light;
        themeProvider.switch2Dest(is2Dark);

        // 第一个一个主题下标（白色）
        int index;
        if (is2Dark) {
          // 保留切换之前主题
          _viewModel.prevIndex = _viewModel.currIndex;
          // 最后一个主题下标（黑色），内部已经-1
          index = ReaderViewModel.lastIndex;
          // 切换网页图标
          _webViewController?.evaluateJavascript(
              source: EbookReaderJsCss.lightIcon);
        } else {
          index = _viewModel.prevIndex;
          // 切换网页图标
          _webViewController?.evaluateJavascript(
              source: EbookReaderJsCss.darkIcon);
        }
        // 保存主题下标（黑色）
        _viewModel.currIndex = index;
        // 切换设置面板颜色
        settingSheetController.changeTheme(
            is2Dark, _viewModel.currColor ?? Colors.white);
        // 切换网页主题
        _webViewController?.evaluateJavascript(
            source:
                EbookReaderJsCss.switchTheme(_viewModel.themeClassName, index));
      });
    } else {
      // 没有开启跟随系统，可以使用当前主题判断
      // 切换主题
      bool is2Dark = !themeProvider.isDarkMode;
      themeProvider.switch2Dest(is2Dark);
      int index;
      if (is2Dark) {
        // 保留切换之前主题
        _viewModel.prevIndex = _viewModel.currIndex;
        // 最后一个主题下标（黑色）
        index = ReaderViewModel.lastIndex;
        _webViewController?.evaluateJavascript(
            source: EbookReaderJsCss.lightIcon);
      } else {
        index = _viewModel.prevIndex;
        _webViewController?.evaluateJavascript(
            source: EbookReaderJsCss.darkIcon);
      }
      // 保存主题下标
      _viewModel.currIndex = index;
      // 切换设置面板颜色
      settingSheetController.changeTheme(
          is2Dark, _viewModel.currColor ?? Colors.white);
      // 切换网页主题
      _webViewController?.evaluateJavascript(
        source: EbookReaderJsCss.switchTheme(
          _viewModel.themeClassName,
          index,
        ),
      );
    }
    isShowTheme = !isShowTheme;
  }

  // 显示设置
  void _toggleSettingsCallback(List<dynamic> args) {
    if (!isShowBottomSheet) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isShowBottomSheet = !isShowBottomSheet;
  }

  void _innerClickCallback(List<dynamic> args) {
    closeBottomSheet();
  }

  void closeBottomSheet() {
    if (isShowBottomSheet) {
      _animationController.reverse();
      isShowBottomSheet = false;
    }
  }

  Future _setFontSize(int fontSize, int lineHeight) async {
    // 修改字体
    var res = await _webViewController?.evaluateJavascript(
        source: EbookReaderJsCss.setFontSizeCode(fontSize, lineHeight));
    if (res) {
      await _webViewController?.reload();

      // var isDark = themeProvider.isDarkMode;
      // 重写注入样式
      _webViewController?.evaluateJavascript(
        source: _viewModel.generateDefaultThemStyle(),
      );
    }
  }

  Future _setBrightness(double brightness) async {
    try {
      await ScreenBrightness().setScreenBrightness(brightness);
    } catch (e) {
      throw 'Failed to set brightness';
    }
  }

  void _switchTheme(bool is2Dark, int index) {
    // 如果此时开启了跟随系统，需要关闭跟随才能完成切换，否则失效
    if (themeProvider.isSystemTheme) {
      DialogUtils.showQuestionDialog(context,
          title: "切换主题", content: "主动切换主题后，跟随系统主题将被关闭。可在设置中重新开启", confirm: () {
        // 关闭跟随
        themeProvider.closeSystemTheme();
        // 切换外界主题，如果此时外界已经是亮，且当前要切换的主题也是亮色，则无须切换外界主题
        if (MediaQuery.of(context).platformBrightness == Brightness.dark ||
            is2Dark) {
          themeProvider.switch2Dest(is2Dark);
          if (is2Dark) {
            _webViewController?.evaluateJavascript(
                source: EbookReaderJsCss.lightIcon);
          } else {
            _webViewController?.evaluateJavascript(
                source: EbookReaderJsCss.darkIcon);
          }
        }
        // 使用控制器开始切换动画
        settingSheetController.startAnimation();
        // index，已经保存，这里不用保存
        // 切换网页主题
        _webViewController?.evaluateJavascript(
          source: EbookReaderJsCss.switchTheme(
            _viewModel.themeClassName,
            index,
          ),
        );
      });
    } else {
      // 切换外界主题，如果此时外界已经是亮，且当前要切换的主题也是亮色，则无须切换外界主题
      if (themeProvider.isDarkMode || is2Dark) {
        themeProvider.switch2Dest(is2Dark);
        // 切换图标
        if (is2Dark) {
          _webViewController?.evaluateJavascript(
              source: EbookReaderJsCss.lightIcon);
        } else {
          _webViewController?.evaluateJavascript(
              source: EbookReaderJsCss.darkIcon);
        }
      }
      // 使用控制器开始切换动画
      settingSheetController.startAnimation();
      // index，已经保存，这里不用保存
      // 切换网页主题
      _webViewController?.evaluateJavascript(
        source: EbookReaderJsCss.switchTheme(
          _viewModel.themeClassName,
          index,
        ),
      );
    }
  }
}
