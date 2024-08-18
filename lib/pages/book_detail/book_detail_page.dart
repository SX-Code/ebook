import 'package:e_book_clone/components/app_bar/my_book_detail_appbar.dart';
import 'package:e_book_clone/components/author_tile/my_author_tile.dart';
import 'package:e_book_clone/components/book_detail_tile/my_book_content_tile.dart';
import 'package:e_book_clone/components/book_detail_tile/my_book_detail_tile.dart';
import 'package:e_book_clone/components/book_review_tile/my_book_review_tile.dart';
import 'package:e_book_clone/components/book_tile/book_tile_horizon/my_book_tile.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:e_book_clone/models/review.dart';
import 'package:e_book_clone/models/types.dart';
import 'package:e_book_clone/pages/book_detail/book_detail_vm.dart';
import 'package:e_book_clone/utils/navigator_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;
  const BookDetailPage({super.key, required this.book});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final BookDetailViewModel _viewModel = BookDetailViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.initData(widget.book);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(160.h),
          child: _getAppBarUI(),
        ),
        body: _getBodyUI(),
      ),
    );
  }

  Widget _getAppBarUI() {
    return MyBookDetailAppbar(
      cover: widget.book.cover ?? "",
      subtitle: widget.book.subTitle ?? widget.book.authorName ?? "",
      title: widget.book.title ?? "",
      actionsWidget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 左侧返回图标
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),

          // 右侧网页链接
          IconButton(
            tooltip: '在线链接',
            onPressed: () {},
            icon: Icon(
              Icons.link,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBodyUI() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(15.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.verticalSpace,
          // 定价、页数、评分
          Selector<BookDetailViewModel, Book?>(
            builder: (context, book, child) {
              List<String>? data;
              if (book?.page != null) {
                data = ['¥${book?.price}', '${book?.page}', '${book?.rate}'];
              }
              return MyBookDetailTile(
                labels: const ["定价", "页数", "评分"],
                data: data,
              );
            },
            selector: (_, viewModel) => viewModel.book,
          ),
          30.verticalSpace,

          // 内容简介
          Selector<BookDetailViewModel, Book?>(
            builder: (context, book, child) {
              return MyBookContentTile(
                book: book,
                labelTitle: '当前版本有售',
              );
            },
            selector: (_, viewModel) => viewModel.book,
          ),

          // 作者，MyAuthorTile，内部有边距
          Selector<BookDetailViewModel, List?>(
            builder: (context, authors, child) {
              return MyAuthorTile(
                authors: authors,
              );
            },
            selector: (_, viewModel) => viewModel.authors,
          ),

          30.verticalSpace,

          // 书评
          Selector<BookDetailViewModel, List<Review>?>(
            builder: (context, reviews, child) {
              return MyBookReviewTile(
                reviews: reviews,
              );
            },
            selector: (_, viewModel) => viewModel.reviews,
          ),

          // 相似
          // 特别为您准备
          Selector<BookDetailViewModel, List<Book>?>(
            builder: (context, books, child) {
              return MyBookTile(
                label: '特别为您准备',
                books: books,
                width: 120.w,
                height: 160.h,
                showRate: true,
                itemTap: (book) {
                  // 跳转到详情页面
                  NavigatorUtils.nav2Detail(context, DetailPageType.book, book);
                },
              );
            },
            selector: (_, viewModel) => viewModel.similarBooks,
          ),
        ],
      ),
    );
  }
}
