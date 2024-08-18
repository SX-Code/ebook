import 'package:e_book_clone/components/book_tile/book_tile_auto/my_book_tile_item_auto.dart';
import 'package:e_book_clone/components/book_tile/book_tile_auto/my_book_tile_item_auto_skeleton.dart';
import 'package:e_book_clone/components/my_smart_refresh.dart';
import 'package:e_book_clone/models/types.dart';
import 'package:e_book_clone/pages/book_more_tab/book_more_tab_vm.dart';
import 'package:e_book_clone/utils/navigator_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BookMoreTabView extends StatefulWidget {
  final String subcat;
  final MorePageType type;

  const BookMoreTabView({super.key, required this.subcat, required this.type});

  @override
  State<BookMoreTabView> createState() => _BookMoreTabPageState();
}

/// https://blog.csdn.net/haha223545/article/details/103056292
/// 混入AutomaticKeepAliveClientMixin，重写 wantKeepAlive 返回 true，可以实现tabview缓存功能
/// 每次切换tab，不会重写构建页面
class _BookMoreTabPageState extends State<BookMoreTabView>
    with AutomaticKeepAliveClientMixin {
  final BookMoreTabViewModel _viewModel = BookMoreTabViewModel();
  late RefreshController refreshController;
  bool showToTopBtn = true;

  @override
  void initState() {
    super.initState();
    refreshController = RefreshController();
    refreshOrLoad(false);
  }

  void refreshOrLoad(bool loadMore) {
    _viewModel
        .getSubcatExpressBooks(widget.subcat, widget.type.path, loadMore)
        .then((value) {
      if (loadMore) {
        refreshController.loadComplete();
      } else {
        refreshController.refreshCompleted();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<BookMoreTabViewModel>.value(
      value: _viewModel,
      child: Consumer<BookMoreTabViewModel>(builder: (context, vm, child) {
        return MySmartRefresh(
          controller: refreshController,
          onRefresh: () {
            refreshOrLoad(false);
          },
          onLoading: () {
            refreshOrLoad(true);
          },
          child: _geGridViewUI(),
        );
      }),
    );
  }

  Widget _geGridViewUI() {
    return Consumer<BookMoreTabViewModel>(
      builder: (context, vm, child) {
        return GridView.builder(
          padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 15.w,
            crossAxisSpacing: 15.w,
            childAspectRatio: 0.48,
          ),
          itemCount: vm.expressBooks?.length ?? 10,
          itemBuilder: (context, index) {
            if (vm.expressBooks == null) {
              return const MyBookTileItemAutoSkeleton();
            }
            return GestureDetector(
              onTap: () {
                NavigatorUtils.nav2Detail(
                    context, DetailPageType.book, vm.expressBooks![index]);
              },
              child: MyBookTileItemAuto(
                book: vm.expressBooks![index],
              ),
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
