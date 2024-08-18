import 'package:e_book_clone/components/app_bar/my_app_bar_actions.dart';
import 'package:e_book_clone/components/book_detail_tile/my_book_content_tile.dart';
import 'package:e_book_clone/components/book_detail_tile/my_book_detail_tile.dart';
import 'package:e_book_clone/components/book_review_tile/my_book_review_tile.dart';
import 'package:e_book_clone/components/book_tile/book_tile_horizon/my_book_tile.dart';
import 'package:e_book_clone/components/app_bar/my_book_detail_appbar.dart';
import 'package:e_book_clone/components/web/define_webview.dart';
import 'package:e_book_clone/components/web/webview_page.dart';
import 'package:e_book_clone/http/spider/api_string.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:e_book_clone/models/review.dart';
import 'package:e_book_clone/pages/ebook_detail/ebook_detail_vm.dart';
import 'package:e_book_clone/pages/play_now/play_now_page.dart';
import 'package:e_book_clone/utils/navigator_utils.dart';
import 'package:e_book_clone/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class EBookDetailPage extends StatefulWidget {
  final Book book;

  const EBookDetailPage({super.key, required this.book});

  @override
  State<EBookDetailPage> createState() => _EBookDetailPageState();
}

class _EBookDetailPageState extends State<EBookDetailPage> {
  EBookDetailViewModel viewModel = EBookDetailViewModel();
  
  @override
  void initState() {
    super.initState();
    if (widget.book.id == null) {
      Navigator.pop(context);
    }
    viewModel.getEBookData(widget.book);
    viewModel.getEBookReviews(widget.book.id!);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EBookDetailViewModel>.value(
      value: viewModel,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(150.h),
          child: _getAppBar(),
        ),
        body: _getBodyUI(),
      ),
    );
  }

  Widget _getAppBar() {
    return Selector<EBookDetailViewModel, Book?>(
        builder: (context, book, child) {
          return MyBookDetailAppbar(
            cover: widget.book.cover,
            title: widget.book.title,
            subtitle: book?.subTitle,
            actionsWidget: MyAppBarActions(
              bookmarkTap: () {
                NavigatorUtils.nav2JoinShelfPage(
                  context,
                  '${ApiString.ebookDetailUrl}${widget.book.id}',
                );
              },
              headphoneTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayNowPage(
                      img: widget.book.cover,
                      title: widget.book.title,
                      subTitle: widget.book.subTitle,
                    ),
                  ),
                );
              },
              linkTap: () {
                if (widget.book.id == null) {
                  ToastUtils.showErrorMsg('书籍信息有误，尝试重写进入该页面');
                } else {
                  NavigatorUtils.nav2ReaderPage(context, widget.book.id!);
                }
              },
            ),
          );
        },
        selector: (_, viewModel) => viewModel.book);
  }

  Widget _getBodyUI() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(15.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.verticalSpace,

          // 定价、页数、评分
          Selector<EBookDetailViewModel, Book?>(
            builder: (context, book, child) {
              List<String>? data;
              if (book?.page != null) {
                data = [
                  '¥${book?.price}',
                  '${book?.labelCount}',
                  '${book?.rate}'
                ];
              }
              return MyBookDetailTile(
                labels: const ["特价", '字数', '评分'],
                data: data,
              );
            },
            selector: (_, viewModel) => viewModel.book,
          ),

          30.verticalSpace,

          // 书籍简介
          Selector<EBookDetailViewModel, Book?>(
            builder: (context, book, child) {
              return MyBookContentTile(
                book: book,
                labelTitle: '作品标签',
                showTags: true,
                storeItemTap: (url) {
                  if (url == null || url.isEmpty) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewPage(
                        webViewType: WebViewType.url,
                        loadResource: url,
                        title: book?.title ?? "",
                      ),
                    ),
                  );
                },
              );
            },
            selector: (_, viewModel) => viewModel.book,
          ),

          30.verticalSpace,

          // 书评
          Selector<EBookDetailViewModel, List<Review>?>(
            builder: (context, reviews, child) {
              return MyBookReviewTile(
                reviews: reviews,
              );
            },
            selector: (_, viewModel) => viewModel.reviews,
          ),

          15.verticalSpace,

          // 相似书籍
          Selector<EBookDetailViewModel, List<Book>?>(
            selector: (_, viewModel) => viewModel.recommendEBooks,
            builder: (context, recommend, child) {
              return MyBookTile(
                label: '大家都喜欢',
                books: recommend,
                showAuthor: true,
                itemTap: (book) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EBookDetailPage(book: book),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
