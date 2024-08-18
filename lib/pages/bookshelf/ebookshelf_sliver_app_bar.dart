import 'package:e_book_clone/utils/navigator_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

class BookshelfSliverAppBar extends StatelessWidget {
  final Widget child;
  final Widget? title;
  final String? appBarTitle;

  const BookshelfSliverAppBar({
    super.key,
    required this.child,
    this.title, this.appBarTitle,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return SliverAppBar(
      expandedHeight: 260.h,
      collapsedHeight: 60.h,
      floating: false,
      pinned: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          size: 20.r,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // 跳转到购物车页面
            NavigatorUtils.openInOuterBrowser(
                'https://read.douban.com/bookshelf/');
          },
          icon: Icon(LineIcons.chrome, size: 26.r,),
        ),
      ],
      backgroundColor: cs.surface,
      foregroundColor: cs.onSurface,
      surfaceTintColor: cs.surface,
      title: Text(appBarTitle ?? "", style: TextStyle(fontSize: 18.sp),),
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.only(bottom: 15.h, left: 20.w),
          child: child,
        ),
        title: title,
        centerTitle: true,
        titlePadding: const EdgeInsets.only(left: 0, right: 0, top: 0),
        expandedTitleScale: 1,
      ),
    );
  }
}
