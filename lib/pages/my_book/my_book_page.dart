import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_book_clone/components/book_tile/book_tile_horizon/my_book_tile.dart';
import 'package:e_book_clone/components/book_tile/book_tile_vertical/my_book_tile_vertical.dart';
import 'package:e_book_clone/models/ebookshelf.dart';
import 'package:e_book_clone/models/types.dart';
import 'package:e_book_clone/models/user_info.dart';
import 'package:e_book_clone/pages/bottom_nav_provider.dart';
import 'package:e_book_clone/pages/my_book/my_book_vm.dart';
import 'package:e_book_clone/theme/theme_provider.dart';
import 'package:e_book_clone/user/user_provider.dart';
import 'package:e_book_clone/utils/design.dart';
import 'package:e_book_clone/utils/dialog_utils.dart';
import 'package:e_book_clone/utils/header.dart';
import 'package:e_book_clone/utils/log_utils.dart';
import 'package:e_book_clone/utils/navigator_utils.dart';
import 'package:e_book_clone/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class MyBookPage extends StatefulWidget {
  final int pageIndex;

  const MyBookPage({super.key, required this.pageIndex});

  @override
  State<MyBookPage> createState() => _MyBookPageState();
}

class _MyBookPageState extends State<MyBookPage> {
  late TextEditingController searchController;
  final MyBookViewModel _viewModel = MyBookViewModel();
  late ThemeProvider _themeProvider;
  bool isNeedRefres = false;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    refresh();
    // 添加刷新方法到 BottomNavProvider
    Future.microtask(() {
      Provider.of<BottomNavProvider>(context, listen: false)
          .refreshFuncs[widget.pageIndex] = refresh;
    });
  }

  void refresh() {
    _viewModel.getData(() {
      Provider.of<UserProvider>(context, listen: false).clearUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final surf = Theme.of(context).colorScheme.surface;
    return Consumer<UserProvider>(
      builder: (context, vm, child) {
        return ChangeNotifierProvider<MyBookViewModel>.value(
          value: _viewModel,
          builder: (context, child) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                toolbarHeight: 0,
                backgroundColor: surf,
                surfaceTintColor: surf,
              ),
              backgroundColor: surf,
              body: _getBodyUI(vm.userInfo),
            );
          },
        );
      },
    );
  }

  Widget _getBodyUI(UserInfo? userInfo) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(MyDesign.paddingPage),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.verticalSpace,
            // 搜索 和 购物车
            _getHeaderUI(userInfo),

            MyDesign.spaceVTile,

            Selector<MyBookViewModel, EBookshelf?>(
              shouldRebuild: (previous, next) =>
                  previous != next ||
                  previous?.books.length != next?.books.length,
              builder: (context, reading, child) {
                return MyBookTile(
                  width: 150.w,
                  height: 200.h,
                  books: reading?.books,
                  isProgress: true,
                  label: '继续阅读  (${reading?.total ?? 0})',
                  moreTap: () {
                    NavigatorUtils.nav2Bookshelf(
                      context,
                      userInfo?.id,
                      processType: EBookProgressType.reading,
                    );
                  },
                  itemTap: (book) {
                    LogUtils.println('继续${book.id}');
                    if (book.id == null || book.id!.isEmpty) {
                      ToastUtils.showErrorMsg('书籍信息有误，尝试重写进入该页面');
                    } else {
                      isNeedRefres = true;
                      NavigatorUtils.nav2ReaderPage(context, book.id!,
                          callback: () {
                        if (isNeedRefres) {
                          // 刷新数据
                          refresh();
                          isNeedRefres = false;
                        }
                      });
                    }
                  },
                );
              },
              selector: (_, viewModel) => viewModel.reading,
            ),

            MyDesign.spaceVTile,

            Selector<MyBookViewModel, EBookshelf?>(
              builder: (context, unreading, child) {
                return MyBookTileVertical(
                  label: "未读(${unreading?.total ?? 0})",
                  books: unreading?.books,
                  moreTap: () {
                    NavigatorUtils.nav2Bookshelf(
                      context,
                      userInfo?.id,
                      processType: EBookProgressType.never,
                    );
                  },
                  bookItemTap: (bookId) {
                    if (bookId.isEmpty) {
                      ToastUtils.showErrorMsg('书籍信息错误');
                    } else {
                      isNeedRefres = true;
                      NavigatorUtils.nav2ReaderPage(context, bookId,
                          callback: () {
                        if (isNeedRefres) {
                          // 刷新数据
                          refresh();
                          isNeedRefres = false;
                        }
                      });
                    }
                  },
                );
              },
              selector: (_, viewModel) => viewModel.unreading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getHeaderUI(UserInfo? userInfo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: IntrinsicWidth(
            child: SizedBox(
              height: 40.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (userInfo == null) {
                        isNeedRefres = true;
                        NavigatorUtils.nav2LoginPage(context, callback: () {
                          refresh();
                          isNeedRefres = false;
                        });
                      }
                    },
                    child: CircleAvatar(
                      backgroundImage: (userInfo?.avatar == null)
                          ? const AssetImage("images/default-avatar.jpeg")
                          : CachedNetworkImageProvider(
                              userInfo!.avatar!,
                              headers: HeaderUtil.randomHeader(),
                            ),
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    userInfo?.username ?? '未登录',
                    style:
                        TextStyle(fontSize: 16.r, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 10.w),
          child: IconButton(
            padding: EdgeInsets.zero,
            tooltip: '我的书架',
            onPressed: () {
              NavigatorUtils.nav2Bookshelf(context, userInfo?.id);
            },
            icon: Icon(LineIcons.stream, size: 25.r),
          ),
        ),
        Selector<ThemeProvider, bool>(
          builder: (context, isDarkMode, child) {
            if (_themeProvider.isSystemTheme) {
              // 跟随系统后，isDarkMode不可信
              isDarkMode =
                  MediaQuery.of(context).platformBrightness == Brightness.dark;
            }
            return IconButton(
              tooltip: '切换主题',
              padding: EdgeInsets.zero,
              onPressed: () {
                // 如果此时开启了跟随系统，需要关闭跟随才能完成切换，否则失效
                if (_themeProvider.isSystemTheme) {
                  DialogUtils.showQuestionDialog(context,
                      title: "切换主题",
                      content: "主动切换主题后，跟随系统主题将被关闭。可在设置中重新开启", confirm: () {
                    // 关闭跟随
                    Provider.of<ThemeProvider>(context, listen: false)
                        .closeSystemTheme();
                    // 切换主题
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                  });
                } else {
                  // 切换主题
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                }
              },
              icon:
                  Icon(isDarkMode ? LineIcons.sun : LineIcons.moon, size: 25.r),
            );
          },
          selector: (_, viewmodel) => viewmodel.isDarkMode,
        ),
        IconButton(
          padding: EdgeInsets.zero,
          tooltip: '设置',
          onPressed: () {
            NavigatorUtils.nav2Settings(context);
          },
          icon: Icon(LineIcons.cog, size: 25.r),
        ),
      ],
    );
  }
}
