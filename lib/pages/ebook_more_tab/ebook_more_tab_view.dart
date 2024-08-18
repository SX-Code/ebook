import 'package:e_book_clone/components/book_tile/book_tile_auto/my_book_tile_item_auto.dart';
import 'package:e_book_clone/components/book_tile/book_tile_auto/my_book_tile_item_auto_skeleton.dart';
import 'package:e_book_clone/components/my_smart_refresh.dart';
import 'package:e_book_clone/models/query_param.dart';
import 'package:e_book_clone/models/types.dart';
import 'package:e_book_clone/pages/ebook_more_tab/ebook_more_tab_vm.dart';
import 'package:e_book_clone/utils/navigator_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EbookMoreTabView extends StatefulWidget {
  final String sort;
  final int kind;
  final MorePageType pageType;
  final bool? isPromotion;
  final String? topicId;
  final Function(int total)? appBarTitleCallback;

  const EbookMoreTabView({
    super.key,
    required this.sort,
    required this.kind,
    this.isPromotion,
    required this.pageType,
    this.topicId,
    this.appBarTitleCallback,
  });

  @override
  State<EbookMoreTabView> createState() => _EbookMoreTabViewState();
}

class _EbookMoreTabViewState extends State<EbookMoreTabView>
    with AutomaticKeepAliveClientMixin {
  final EBookMoreViewModel _viewModel = EBookMoreViewModel();
  late RefreshController _refreshController;
  late final QueryParam queryParam;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    // 初始化参数
    queryParam = QueryParam(
      kind: widget.kind,
      sort: widget.sort,
      isPromotion: widget.isPromotion,
      query: QueryParam.ebookQuery,
    );

    refreshOrLoad(false);
  }

  void refreshOrLoad(bool loadMore) {
    _viewModel
        .getMoreEBook(
      queryParam,
      loadMore,
      widget.pageType,
      topicId: widget.topicId,
    ).then((total) {
      if (loadMore) {
        _refreshController.loadComplete();
      } else {
        _refreshController.refreshCompleted();
      }
      widget.appBarTitleCallback?.call(total);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<EBookMoreViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: MySmartRefresh(
          onLoading: () => refreshOrLoad(true),
          onRefresh: () => refreshOrLoad(false),
          controller: _refreshController,
          child: _geGridViewUI(),
        ),
      ),
    );
  }

  Widget _geGridViewUI() {
    return Consumer<EBookMoreViewModel>(
      builder: (context, vm, child) {
        return GridView.builder(
          padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 15.w,
            childAspectRatio: 0.48,
          ),
          itemCount: vm.more?.length ?? 6,
          itemBuilder: (context, index) {
            if (vm.more == null) {
              return const MyBookTileItemAutoSkeleton(
                showRate: false,
              );
            }
            return GestureDetector(
              onTap: () {
                NavigatorUtils.nav2Detail(
                    context, DetailPageType.book, vm.more![index]);
              },
              child: MyBookTileItemAuto(
                showRate: false,
                book: vm.more![index],
              ),
            );
          },
        );
      },
    );
  }
}
