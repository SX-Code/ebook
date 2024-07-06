import 'package:e_book_demo/model/book.dart';
import 'package:e_book_demo/model/ebook_category.dart';
import 'package:e_book_demo/pages/components/book_tile/my_book_tile.dart';
import 'package:e_book_demo/pages/components/ebook_category_tile/my_ebook_category_tile.dart';
import 'package:e_book_demo/pages/components/my_search_tile.dart';
import 'package:e_book_demo/pages/ebook_store/ebook_store_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class EbookStorePage extends StatefulWidget {
  const EbookStorePage({super.key});

  @override
  State<EbookStorePage> createState() => _EbookStorePageState();
}

class _EbookStorePageState extends State<EbookStorePage> {
  final EbookStoreViewModel _viewModel = EbookStoreViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.getEBookStoreData();
  }
  
  @override
  Widget build(BuildContext context) {
    Color surf = Theme.of(context).colorScheme.surface;
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          backgroundColor: surf,
          surfaceTintColor: surf,
        ),
        backgroundColor: surf,
        body: Padding(
          padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.w),
          child: _getBodyUI(),
        ),
      ),
    );
  }

  Widget _getBodyUI() {
    // 也可使用 SingleScroll
    return CustomScrollView(
      slivers: [
        // 搜索
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: MySearchTile(
              bookshelfTap: () {},
            ),
          ),
        ),

        // 编辑推荐
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 30.h),
            child: Selector<EbookStoreViewModel, List<Book>?>(
                builder: (context, books, child) {
                  return MyBookTile(
                    books: books,
                    showPrice: true,
                    title: '编辑推荐',

                  );
                },
                selector: (_, viewModel) => viewModel.recommend),
          ),
        ),

        // 图书标签
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 30.h),
            child: Selector<EbookStoreViewModel, List<EBookCategory>?>(
                builder: (context, categories, child) {
                  return MyEBookCategoryTile(
                    categories: categories,
                    title: '图书标签',
                  );
                },
                selector: (_, viewModel) => viewModel.categories),
          ),
        ),

      ],
    );
  }
}
