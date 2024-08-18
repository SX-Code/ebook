import 'package:e_book_clone/components/book_tile/book_tile_vertical/my_book_tile_vertical_item.dart';
import 'package:e_book_clone/components/book_tile/book_tile_vertical/my_book_tile_vertical_item_skeleton.dart';
import 'package:e_book_clone/components/my_smart_refresh.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:e_book_clone/models/types.dart';
import 'package:e_book_clone/pages/search/search_vm.dart';
import 'package:e_book_clone/utils/navigator_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchResultPage extends StatefulWidget {
  final String query;
  const SearchResultPage({super.key, required this.query});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final RefreshController _refreshController = RefreshController();
  final SearchViewModel _viewModel = SearchViewModel();
  void loadOrRefresh(bool loadMore) {
    _viewModel.getResults(widget.query, loadMore).then((_) {
      if (loadMore) {
        _refreshController.loadComplete();
      } else {
        _refreshController.refreshCompleted();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadOrRefresh(false);
  }

  @override
  void dispose() {
    _viewModel.isDispose = true;
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchViewModel>.value(
      value:  _viewModel,
      builder: (context, child) {
        return Consumer<SearchViewModel>(
          builder: (context, vm, child) {
            List<Book>? searchResult = vm.searchResult;
            return MySmartRefresh(
              enablePullDown: false,
              onLoading: () {
                loadOrRefresh(true);
              },
              controller: _refreshController,
              child: ListView.builder(
                padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h),
                itemCount: searchResult?.length ?? 10,
                itemBuilder: (context, index) {
                  if (searchResult == null) {
                    return MyBookTileVerticalItemSkeleton(
                        width: 80.w, height: 120.h);
                  }
                  return MyBookTileVerticalItem(
                    book: searchResult[index],
                    width: 80.w,
                    height: 120.h,
                    onTap: (id) {
                      NavigatorUtils.nav2Detail(
                          context, DetailPageType.ebook, searchResult[index]);
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}