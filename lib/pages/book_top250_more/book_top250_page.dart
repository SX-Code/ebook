import 'package:e_book_clone/components/book_tile/book_tile_auto/my_book_tile_item_auto.dart';
import 'package:e_book_clone/components/book_tile/book_tile_auto/my_book_tile_item_auto_skeleton.dart';
import 'package:e_book_clone/components/my_smart_refresh.dart';
import 'package:e_book_clone/http/spider/api_string.dart';
import 'package:e_book_clone/models/types.dart';
import 'package:e_book_clone/pages/book_top250_more/book_top250_vm.dart';
import 'package:e_book_clone/utils/design.dart';
import 'package:e_book_clone/utils/navigator_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BookTop250Page extends StatefulWidget {
  const BookTop250Page({super.key});

  @override
  State<BookTop250Page> createState() => _BookTop250PageState();
}

class _BookTop250PageState extends State<BookTop250Page> {
  final BookTop250ViewModel _viewModel = BookTop250ViewModel();
  final RefreshController refreshController = RefreshController();
  late ScrollController _scrollController;
  bool showToTopBtn = false;

  @override
  void initState() {
    super.initState();
    refreshOrLoad(false);
    _scrollController = ScrollController();
    // 滚动监听，返回顶部
    _scrollController.addListener(() {
      if (_scrollController.offset < 1000 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else if (_scrollController.offset >= 1000 && showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });
  }

  void refreshOrLoad(bool loadMore) {
    _viewModel.getTop250Books(loadMore).then((value) {
      if (loadMore) {
        refreshController.loadComplete();
      } else {
        refreshController.refreshCompleted();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookTop250ViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: _getAppBar(),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        floatingActionButton: !showToTopBtn
            ? null
            : FloatingActionButton(
                onPressed: () {
                  _scrollController.animateTo(
                    .0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.ease,
                  );
                },
                child: const Icon(Icons.arrow_upward),
              ),
        body: MySmartRefresh(
          onLoading: () => refreshOrLoad(true),
          onRefresh: () => refreshOrLoad(false),
          scrollController: _scrollController,
          controller: refreshController,
          child: Padding(
            padding: EdgeInsets.only(
              left: MyDesign.widthPageMargin,
              right: MyDesign.widthPageMargin,
              top: MyDesign.heightPageMargin,
            ),
            child: _geGridViewUI(),
          ),
        ),
      ),
    );
  }

  Widget _getAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      automaticallyImplyLeading: false,
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
            NavigatorUtils.openInOuterBrowser(ApiString.bookTop250Url);
          },
          icon: Icon(LineIcons.chrome, size: 26.r),
        )
      ],
      title: Text(
        'Top250',
        style: TextStyle(fontSize: MyDesign.fontSizeAppBarTitle),
      ),
    );
  }

  Widget _geGridViewUI() {
    return Consumer<BookTop250ViewModel>(
      builder: (context, vm, child) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 15.w,
            crossAxisSpacing: 15.w,
            childAspectRatio: 0.45,
          ),
          itemCount: vm.top250Books?.length ?? 10,
          itemBuilder: (context, index) {
            if (vm.top250Books == null) {
              return const MyBookTileItemAutoSkeleton();
            }
            return GestureDetector(
              onTap: () {
                NavigatorUtils.nav2Detail(
                    context, DetailPageType.book, vm.top250Books![index]);
              },
              child: MyBookTileItemAuto(
                book: vm.top250Books![index],
                showFav: false,
              ),
            );
          },
        );
      },
    );
  }
}
