import 'package:e_book_clone/models/types.dart';
import 'package:e_book_clone/pages/book_more_tab/book_more_tab_view.dart';
import 'package:e_book_clone/utils/navigator_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

class BookMoreTabPage extends StatefulWidget {
  final String? title;
  final MorePageType pageType;

  const BookMoreTabPage({super.key, this.title, required this.pageType});

  @override
  State<BookMoreTabPage> createState() => _BookMoreTabPageState();
}

class _BookMoreTabPageState extends State<BookMoreTabPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool showToTopBtn = false;
  late List<String> names;

  @override
  void initState() {
    super.initState();
    if (widget.pageType == MorePageType.bookExpress) {
      names = BookExpressSubcat.names();
    } else {
      names = BookWeeklySubcat.names();
    }
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Tab> _buildTabs() {
    return names.map((name) {
      return Tab(text: name);
    }).toList();
  }

  List<Widget> _buildTabViews() {
    List<Widget> tabViews;
    if (widget.pageType == MorePageType.bookExpress) {
      tabViews = BookExpressSubcat.values.map((value) {
        return BookMoreTabView(subcat: value.subcat, type: widget.pageType);
      }).toList();
    } else {
      tabViews = BookWeeklySubcat.values.map((value) {
        return BookMoreTabView(subcat: value.subcat, type: widget.pageType);
      }).toList();
    }
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
                widget.title ?? "",
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
                    NavigatorUtils.openInOuterBrowser(widget.pageType.path);
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
