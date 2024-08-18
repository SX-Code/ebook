import 'package:e_book_clone/components/book_tile/book_tile_vertical/my_book_tile_vertical_item.dart';
import 'package:e_book_clone/components/book_tile/book_tile_vertical/my_book_tile_vertical_item_skeleton.dart';
import 'package:e_book_clone/components/my_choice_tile.dart';
import 'package:e_book_clone/components/my_smart_refresh.dart';
import 'package:e_book_clone/models/types.dart';
import 'package:e_book_clone/pages/bookshelf/ebookshelf_sliver_app_bar.dart';
import 'package:e_book_clone/pages/bookshelf/ebooshelf_vm.dart';
import 'package:e_book_clone/user/user_provider.dart';
import 'package:e_book_clone/utils/navigator_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BookshelfPage extends StatefulWidget {
  final EBookProgressType? progressType;
  const BookshelfPage({super.key, this.progressType});

  @override
  State<BookshelfPage> createState() => _BookshelfPageState();
}

class _BookshelfPageState extends State<BookshelfPage> {
  final EBooshelfViewModel _viewModel = EBooshelfViewModel();
  final RefreshController _refreshController = RefreshController();
  Map<String, dynamic> variables = {
    "progress": null,
    "isFinalized": null,
    "updatedDays": null,
    "vipCanRead": null,
    "hasOwned": null,
    "userId": "263571520",
  };

  @override
  void dispose() {
    _viewModel.isDispose = true;
    super.dispose();
  }

  void refreshData(bool loadMore) {
    // 初始化参数，可从跳转传递
    if (widget.progressType != null) {
      variables['progress'] = widget.progressType!.value;
    }
    _viewModel.getData(variables, loadMore, needLoginCallback: () {
      // 删除缓存
      Provider.of<UserProvider>(context).clearUserInfo();
    }).then((_) {
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
    refreshData(false);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EBooshelfViewModel>.value(
      value: _viewModel,
      builder: (context, child) {
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              Selector<EBooshelfViewModel, int?>(
                  builder: (context, total, child) {
                    return BookshelfSliverAppBar(
                      appBarTitle: '我的书架(${total ?? 0})',
                      child: _getHeaderFilterUI(),
                    );
                  },
                  selector: (_, viewmodel) => viewmodel.shelfBook?.total)
            ],
            body: MySmartRefresh(
              controller: _refreshController,
              onLoading: () => refreshData(true),
              enablePullDown: false,
              child: Consumer<EBooshelfViewModel>(
                builder: (context, vm, child) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h),
                    itemCount: vm.shelfBook?.books.length ?? 5,
                    itemBuilder: (context, index) {
                      if (vm.shelfBook == null) {
                        // 骨架屏
                        return MyBookTileVerticalItemSkeleton(
                          width: 80.w,
                          height: 105.h,
                        );
                      }
                      return MyBookTileVerticalItem(
                        book: vm.shelfBook!.books[index],
                        width: 80.w,
                        height: 105.h,
                        onTap: (id) {
                          NavigatorUtils.nav2ReaderPage(context, id);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _getHeaderFilterUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Table(
          columnWidths: {
            0: FixedColumnWidth(65.w),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: [
              const Text('连载状态'),
              MyChoiceTile(
                types: EBookSerialStatus.map(),
                choiced: (value) {
                  variables['isFinalized'] = value;
                  refreshData(false);
                },
              ),
            ]),
            TableRow(children: [
              const Text('阅读进度'),
              MyChoiceTile(
                defaultIndex: widget.progressType?.index,
                types: EBookProgressType.map(),
                choiced: (value) {
                  variables['progress'] = value;
                  refreshData(false);
                },
              ),
            ]),
            TableRow(children: [
              const Text('更新'),
              MyChoiceTile(
                types: EBookUpdatedDays.map(),
                choiced: (value) {
                  variables['updatedDays'] = value;
                  refreshData(false);
                },
              ),
            ]),
            TableRow(children: [
              const Text('付费'),
              MyChoiceTile(
                types: EBookHasOwned.map(),
                choiced: (value) {
                  variables['hasOwned'] = value;
                  refreshData(false);
                },
              )
            ])
          ],
        )
      ],
    );
  }
}
