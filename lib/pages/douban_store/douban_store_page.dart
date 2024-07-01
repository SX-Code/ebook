import 'package:e_book_demo/model/book.dart';
import 'package:e_book_demo/pages/components/book_tile/my_book_tile.dart';
import 'package:e_book_demo/pages/components/my_search_tile.dart';
import 'package:e_book_demo/pages/douban_store/douban_store_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DoubanStorePage extends StatefulWidget {
  const DoubanStorePage({super.key});

  @override
  State<DoubanStorePage> createState() => _DoubanStorePageState();
}

class _DoubanStorePageState extends State<DoubanStorePage> {
  final DoubanStoreViewModel _viewModel = DoubanStoreViewModel();

  @override
  void initState() {
    super.initState();
    // 初始化数据
    _viewModel.getDoubanStoreData();
  }
  @override
  Widget build(BuildContext context) {
    Color surf = Theme.of(context).colorScheme.surface;
    return ChangeNotifierProvider.value(
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
          body: _getBodyUI(),
        );
      },
    );
  }

  Widget _getBodyUI() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(right: 15.w, top: 15.w, left: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.verticalSpace,
            // 搜索
            const MySearchTile(),

            30.verticalSpace,

            // 新书速递
            Selector<DoubanStoreViewModel, List<Book>?>(
              builder: (context, books, child) {
                return MyBookTile(
                  books: books,
                  title: '新书速递',
                  width: 120.w,
                  height: 160.h,
                );
              },
              selector: (_, viewModel) => viewModel.expressBooks,
            ),

            30.verticalSpace,

            // 一周热门
            Selector<DoubanStoreViewModel, List<Book>?>(
              builder: (context, books, child) {
                return MyBookTile(
                  books: books,
                  title: '一周热门图书榜',
                  width: 120.w,
                  height: 160.h,
                  showRate: true,
                );
              },
              selector: (_, viewModel) => viewModel.weeklyBooks,
            ),

            30.verticalSpace,

            // top250
            Selector<DoubanStoreViewModel, List<Book>?>(
              builder: (context, books, child) {
                return MyBookTile(
                  books: books,
                  title: '豆瓣阅读Top250',
                  width: 120.w,
                  height: 160.h,
                );
              },
              selector: (_, viewModel) => viewModel.top250Books,
            ),
          ],
        ),
      ),
    );
  }
}
