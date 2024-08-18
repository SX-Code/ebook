import 'package:e_book_clone/components/book_tile/book_tile_horizon/my_book_tile.dart';
import 'package:e_book_clone/components/ebook_category/my_ebbok_category_tile.dart';
import 'package:e_book_clone/components/ebook_category/my_ebbok_category_tile_skeleton.dart';
import 'package:e_book_clone/components/my_search_tile.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:e_book_clone/models/ebook_topic.dart';
import 'package:e_book_clone/models/types.dart';
import 'package:e_book_clone/pages/bottom_nav_provider.dart';
import 'package:e_book_clone/pages/ebook_detail/ebook_detail_page.dart';
import 'package:e_book_clone/pages/ebook_store/store_vm.dart';
import 'package:e_book_clone/utils/design.dart';
import 'package:e_book_clone/utils/navigator_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class StorePage extends StatefulWidget {
  final int pageIndex;
  const StorePage({super.key, required this.pageIndex});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  late TextEditingController searchController;
  final StoreViewModel _viewModel = StoreViewModel();

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    // 添加刷新方法到 BottomNavProvider
    Future.microtask(() {
      Provider.of<BottomNavProvider>(context, listen: false)
          .refreshFuncs[widget.pageIndex] = refresh;
    });
    refresh();
  }

  void refresh() {
    _viewModel.getStoreData().then((_) {
      // 获取今日特价
      _viewModel.getDailyDiscount();
      // 获取最新上架
      _viewModel.getNew();
      // 获取话题数据
      _viewModel.getTopics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final surf = Theme.of(context).colorScheme.surface;
    return ChangeNotifierProvider<StoreViewModel>.value(
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
          padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h),
          child: _getBodyUI(),
        ),
      ),
    );
  }

  Widget _getBodyUI() {
    return CustomScrollView(
      slivers: [
        // 搜索
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: MySearchTile(
              hintText: '搜索..',
              textEditingController: searchController,
            ),
          ),
        ),

        // 编辑推荐
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 30.h),
            child: Selector<StoreViewModel, List<Book>?>(
              selector: (_, storeViewModel) => storeViewModel.recommend,
              builder: (context, books, child) {
                return MyBookTile(
                  label: '编辑推荐',
                  books: books,
                  showAuthor: true,
                  showRate: false,
                  itemTap: (book) {
                    NavigatorUtils.nav2Detail(
                        context, DetailPageType.ebook, book);
                  },
                );
              },
            ),
          ),
        ),

        // 标签
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 30.h),
            child: Selector<StoreViewModel, List<Category>?>(
                builder: (context, categories, child) {
                  if (categories == null) {
                    return const MyEbbokCategoryTileSkeleton();
                  }
                  return MyEbbokCategoryTile(
                    categories: categories,
                    itemTap: (url) {
                      NavigatorUtils.nav2WebView(context, url);
                    },
                  );
                },
                selector: (_, viewModel) => viewModel.categories),
          ),
        ),

        // 今日特价
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 30.h),
            child: Selector<StoreViewModel, List<Book>?>(
              selector: (_, storeViewModel) => storeViewModel.discount,
              builder: (context, discountBooks, child) {
                return MyBookTile(
                  label: '今日特价',
                  books: discountBooks,
                  showAuthor: true,
                  showRate: false,
                  itemTap: (book) {
                    NavigatorUtils.nav2Detail(
                        context, DetailPageType.ebook, book);
                  },
                  moreTap: () {
                    NavigatorUtils.nav2EBookMorePage(
                      context,
                      "今日特价",
                      isPromotion: true,
                    );
                  },
                );
              },
            ),
          ),
        ),

        // 最新上架
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 30.h),
            child: Selector<StoreViewModel, List<Book>?>(
              selector: (_, storeViewModel) => storeViewModel.newEbook,
              builder: (context, discountBooks, child) {
                return MyBookTile(
                  label: '最新上架',
                  books: discountBooks,
                  showAuthor: true,
                  showRate: false,
                  itemTap: (book) {
                    NavigatorUtils.nav2Detail(
                        context, DetailPageType.ebook, book);
                  },
                  moreTap: () {
                    NavigatorUtils.nav2EBookMorePage(
                      context,
                      "最新上架",
                      sort: EBookSort.latest,
                    );
                  },
                );
              },
            ),
          ),
        ),

        // 更多话题
        SliverToBoxAdapter(
          child: Selector<StoreViewModel, List<EBookTopic>?>(
            selector: (_, storeViewModel) => storeViewModel.topics,
            builder: (context, topics, child) {
              if (topics == null) {
                // 骨架屏幕
                return Padding(
                  padding: EdgeInsets.only(top: MyDesign.heightTileMargin),
                  child: const MyBookTile(
                    books: null,
                    label: '更多话题',
                    showRate: false,
                  ),
                );
              }
              return Column(
                children: List.generate(topics.length, (index) {
                  EBookTopic topic = topics[index];
                  String title;
                  if (topic.total != null) {
                    title = '${topic.title}(${topic.total})';
                  } else {
                    title = topic.title;
                  }
                  return Padding(
                    padding: EdgeInsets.only(top: MyDesign.heightTileMargin),
                    child: MyBookTile(
                      label: title,
                      books: topic.ebooks,
                      showAuthor: true,
                      itemTap: (book) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EBookDetailPage(book: book),
                          ),
                        );
                      },
                      moreTap: () {
                        NavigatorUtils.nav2EBookMorePage(
                          context,
                          title,
                          sort: EBookSort.synthesis,
                          topicId: topic.topicId,
                          pageType: MorePageType.topic,
                        );
                      },
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ],
      // )
    );
  }
}
