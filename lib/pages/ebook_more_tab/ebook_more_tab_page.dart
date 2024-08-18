import 'package:e_book_clone/http/spider/api_string.dart';
import 'package:e_book_clone/models/query_param.dart';
import 'package:e_book_clone/models/types.dart';
import 'package:e_book_clone/pages/ebook_more_tab/ebook_more_tab_view.dart';
import 'package:e_book_clone/utils/navigator_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EbookMoreTabPage extends StatefulWidget {
  final String title;
  final EBookSort sort;
  final EBookKind kind;
  final bool isPromotion;
  final MorePageType pageType;
  final String? topicId;

  const EbookMoreTabPage({
    super.key,
    required this.title,
    this.sort = EBookSort.hottest,
    this.kind = EBookKind.all,
    this.isPromotion = false,
    this.pageType = MorePageType.category,
    this.topicId,
  });

  @override
  State<EbookMoreTabPage> createState() => _EbookMoreTabPageState();
}

class _EbookMoreTabPageState extends State<EbookMoreTabPage>
    with SingleTickerProviderStateMixin {
  final RefreshController refreshController = RefreshController();
  late final QueryParam queryParam;
  late TabController _tabController;
  late List<String> names;
  final ScrollController _scrollController = ScrollController();
  bool showToTopBtn = false;

  @override
  void initState() {
    super.initState();
    names = EBookKind.names();
    _tabController = TabController(length: names.length, vsync: this);
    // 滚动监听，返回顶部
    _scrollController.addListener(() {
      if (_scrollController.offset < 100 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else if (_scrollController.offset >= 100 && showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });
  }

  List<Tab> _buildTabs() {
    return names.map((name) {
      return Tab(text: name);
    }).toList();
  }

  List<Widget> _buildTabViews() {
    List<Widget> tabViews;
    tabViews = EBookKind.values.map((value) {
      return EbookMoreTabView(
        kind: value.value,
        isPromotion: widget.isPromotion,
        sort: widget.sort.value,
        pageType: widget.pageType,
        topicId: widget.topicId,
      );
    }).toList();
    return tabViews;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (conetxt, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              surfaceTintColor: Theme.of(context).colorScheme.surface,
              title: Text(
                widget.title,
                style: TextStyle(fontSize: 18.sp),
              ),
              pinned: true,
              floating: true,
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
                    String path;
                    if (widget.pageType == MorePageType.category) {
                      path = widget.pageType.url!;
                    } else if (widget.pageType == MorePageType.topic) {
                      path = "${widget.pageType.url}${widget.topicId}/";
                    } else {
                      path = ApiString.ebookBaseUrl;
                    }
                    NavigatorUtils.openInOuterBrowser(path);
                  },
                  icon: Icon(LineIcons.chrome, size: 26.r),
                )
              ],
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                isScrollable: true,
                dividerHeight: 0,
                tabAlignment: TabAlignment.start,
                controller: _tabController,
                tabs: _buildTabs(),
              ),
            )
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: _buildTabViews(),
        ),
      ),
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
    );
  }
}
