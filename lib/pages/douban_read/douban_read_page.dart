import 'package:e_book_clone/components/book_tile/book_tile_horizon/my_book_tile.dart';
import 'package:e_book_clone/components/my_search_tile.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:e_book_clone/models/types.dart';
import 'package:e_book_clone/pages/book_top250_more/book_top250_page.dart';
import 'package:e_book_clone/pages/bottom_nav_provider.dart';
import 'package:e_book_clone/pages/douban_read/douban_read_vm.dart';
import 'package:e_book_clone/utils/design.dart';
import 'package:e_book_clone/utils/navigator_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DoubanReadPage extends StatefulWidget {
  final int pageIndex;
  const DoubanReadPage({super.key, required this.pageIndex});

  @override
  State<DoubanReadPage> createState() => _DoubanReadPageState();
}

class _DoubanReadPageState extends State<DoubanReadPage> {
  final DoubanReadViewModel _viewModel = DoubanReadViewModel();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 添加刷新方法到 BottomNavProvider
    Future.microtask(() {
      Provider.of<BottomNavProvider>(context, listen: false).refreshFuncs[widget.pageIndex] = refresh;
    });
    refresh();
  }

  void refresh() {
    _viewModel.getDoubanReadDatas();
  }

  @override
  Widget build(BuildContext context) {
    final surf = Theme.of(context).colorScheme.surface;
    return ChangeNotifierProvider<DoubanReadViewModel>.value(
      value:  _viewModel,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          backgroundColor: surf,
          surfaceTintColor: surf,
        ),
        backgroundColor: surf,
        body: _getBodyUI(),
      ),
    );
  }

  Widget _getBodyUI() {
    return SafeArea(
        child: SingleChildScrollView(
      padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h),
      child: Column(
        children: [
          MyDesign.spaceTAppBar,
          MySearchTile(
            hintText: '搜索..',
            textEditingController: searchController,
          ),

          MyDesign.spaceVTile,

          // 新书速递
          Selector<DoubanReadViewModel, List<Book>?>(
            selector: (_, storeViewModel) => storeViewModel.expressBooks,
            builder: (context, books, child) {
              return MyBookTile(
                label: '新书速递',
                books: books,
                showAuthor: true,
                showRate: false,
                itemTap: (book) {
                  NavigatorUtils.nav2Detail(context, DetailPageType.book, book);
                },
                moreTap: () => {
                  NavigatorUtils.nav2BookMorePage(
                      context, '新书速递', MorePageType.bookExpress)
                },
              );
            },
          ),
          MyDesign.spaceVTile,

          // 一周热门图书榜
          Selector<DoubanReadViewModel, List<Book>?>(
            selector: (_, storeViewModel) => storeViewModel.weeklyHotBooks,
            builder: (context, discountBooks, child) {
              return MyBookTile(
                label: '一周热门图书榜',
                books: discountBooks,
                showAuthor: true,
                showRate: false,
                itemTap: (book) {
                  NavigatorUtils.nav2Detail(context, DetailPageType.book, book);
                },
                moreTap: () {
                  NavigatorUtils.nav2BookMorePage(
                      context, '一周热门图书榜', MorePageType.bookWeekly);
                },
              );
            },
          ),

          MyDesign.spaceVTile,

          // 豆瓣图书250
          Selector<DoubanReadViewModel, List<Book>?>(
            selector: (_, storeViewModel) => storeViewModel.top250Books,
            builder: (context, discountBooks, child) {
              return MyBookTile(
                label: '豆瓣图书250 ',
                books: discountBooks,
                showRate: false,
                showAuthor: true,
                itemTap: (book) {
                  NavigatorUtils.nav2Detail(context, DetailPageType.book, book);
                },
                moreTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookTop250Page(),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    ));
  }
}
