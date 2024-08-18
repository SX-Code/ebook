import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_book_clone/components/book_activity/my_book_activity_tile.dart';
import 'package:e_book_clone/components/book_activity_type/my_book_activity_type_tile.dart';
import 'package:e_book_clone/components/book_activity_type/my_book_activity_type_tile_skeleton.dart';
import 'package:e_book_clone/components/book_tile/book_tile_horizon/my_book_tile.dart';
import 'package:e_book_clone/components/my_search_tile.dart';
import 'package:e_book_clone/components/web/define_webview.dart';
import 'package:e_book_clone/components/web/webview_page.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:e_book_clone/models/book_activity.dart';
import 'package:e_book_clone/models/poetry.dart';
import 'package:e_book_clone/models/types.dart';
import 'package:e_book_clone/models/user_info.dart';
import 'package:e_book_clone/pages/bottom_nav_provider.dart';
import 'package:e_book_clone/pages/home/home_vm.dart';
import 'package:e_book_clone/pages/search/my_search_delegate.dart';
import 'package:e_book_clone/pages/search/search_page.dart';
import 'package:e_book_clone/theme/theme_provider.dart';
import 'package:e_book_clone/user/user_provider.dart';
import 'package:e_book_clone/utils/header.dart';
import 'package:e_book_clone/utils/my_date_utils.dart';
import 'package:e_book_clone/utils/navigator_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final int pageIndex;
  const HomePage({super.key, required this.pageIndex});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController searchController;
  HomeViewModel viewmodel = HomeViewModel();

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    refreshPage();
    // 增加刷新
    Future.microtask(() {
      Provider.of<BottomNavProvider>(context, listen: false)
          .refreshFuncs[widget.pageIndex] = refreshPage;
    });
  }

  void refreshPage() {
    viewmodel.getSpecialForYouBooks();
    if (Provider.of<ThemeProvider>(context, listen: false).showDialyPoetry) {
      viewmodel.getDailyPotery();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>.value(
      value: viewmodel,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: _getBody(),
      ),
    );
  }

  Widget _getBody() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(15.r),
        child: Column(
          children: [
            10.verticalSpace,
            // 昵称 和 头像

            Selector<UserProvider, UserInfo?>(
              builder: (context, userInfo, child) {
                String hello = MyDateUtils.getHello();
                String? avatar;
                if (userInfo != null) {
                  if (userInfo.username?.isNotEmpty ?? false) {
                    hello = '$hello, ${userInfo.username}';
                  }
                  avatar = userInfo.avatar;
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      hello,
                      style: TextStyle(
                          fontSize: 22.sp, fontWeight: FontWeight.w600),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (userInfo != null) {
                          Provider.of<BottomNavProvider>(context, listen: false)
                              .currentIndex = 3;
                        } else {
                          NavigatorUtils.nav2LoginPage(context);
                        }
                      },
                      child: CircleAvatar(
                        backgroundImage: (avatar == null)
                            ? const AssetImage("images/default-avatar.jpeg")
                            : CachedNetworkImageProvider(
                                avatar,
                                headers: HeaderUtil.randomHeader(),
                              ),
                      ),
                    ),
                  ],
                );
              },
              selector: (_, viewModel) => viewModel.userInfo,
            ),

            20.verticalSpace,

            // 搜索 和 购物车
            MySearchTile(
              onTap: () {
                showMySearch(context: context, delegate: SearchPage());
              },
              hintText: '搜索',
              textEditingController: searchController,
            ),

            // 每日一诗
            _getSelectionQute(),

            // 读书活动
            Selector<HomeViewModel, List<BookActivity>?>(
                builder: (context, bookActivities, child) {
                  return MyBookActivityTile(
                    bookActivities: bookActivities,
                    activityTap: (String? url, String? title) {
                      if (url == null || url.isEmpty) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewPage(
                            webViewType: WebViewType.url,
                            loadResource: url,
                            showTitle: title != null,
                            title: title,
                          ),
                        ),
                      );
                    },
                  );
                },
                selector: (_, viewModel) => viewModel.bookActivities),

            15.verticalSpace,
            // 所有读书活动
            Selector<HomeViewModel, List<String>?>(
              builder: (context, labels, child) {
                if (labels == null) {
                  return const MyBookActivityTypeTileSkeleton();
                }
                return MyBookActivityTypeTile(
                  labels: labels,
                  itemTap: (index) {
                    int? kind = index == 0 ? null : index - 1;
                    viewmodel.getActivityByKind(kind);
                  },
                );
              },
              selector: (_, viewmodel) => viewmodel.activityLabels,
            ),

            30.verticalSpace,

            // 推荐
            Selector<HomeViewModel, List<Book>?>(
              selector: (_, homeViewModel) => homeViewModel.weeklyBooks,
              builder: (context, books, child) {
                return MyBookTile(
                  label: '特别为您准备',
                  books: books,
                  showMore: false,
                  itemTap: (book) {
                    NavigatorUtils.nav2Detail(
                        context, DetailPageType.book, book);
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

  // 每日一言
  Widget _getSelectionQute() {
    return Selector<ThemeProvider, bool>(
      builder: (context, value, child) {
        if (!value) {
          return const SizedBox();
        }
        return Container(
          margin: EdgeInsets.only(top: 15.h),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 题目
                Text(
                  '每日一诗',
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                10.verticalSpace,
                // 引言

                Selector<HomeViewModel, Poetry?>(
                    builder: (context, poetry, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            poetry?.content ?? "",
                            style: TextStyle(
                                fontSize: 14.sp,
                                height: 1.5,
                                fontWeight: FontWeight.w500),
                          ),
                          10.verticalSpace,

                          // 作者
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              poetry?.author ?? "",
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  height: 1.5,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      );
                    },
                    selector: (_, homeViewModel) => homeViewModel.poetry)
              ],
            ),
          ),
        );
      },
      selector: (_, viewModel) => viewModel.showDialyPoetry,
    );
  }
}
