import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_book_clone/theme/colors.dart';
import 'package:e_book_clone/utils/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyBookDetailAppbar extends StatefulWidget {
  final String? cover;
  final String? title;
  final String? subtitle;
  final Widget? actionsWidget;

  const MyBookDetailAppbar({
    super.key,
    required this.cover,
    required this.title,
    this.subtitle,
    required this.actionsWidget,
  });

  @override
  State<MyBookDetailAppbar> createState() => _MyBookDetailAppbarState();
}

class _MyBookDetailAppbarState extends State<MyBookDetailAppbar> {
  final GlobalKey _key1 = GlobalKey();
  double? _titleLeft; // 标题左边距离
  @override
  Widget build(BuildContext context) {
    // 监听widget渲染完成
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      RenderBox? box = _key1.currentContext?.findRenderObject() as RenderBox?;
      if (_titleLeft == null) {
        _titleLeft = box?.size.width;
        setState(() {}); // 拿到距离之后刷新
      }
    });
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: Stack(
        children: [
          // 封面， 背景
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  widget.cover ?? "",
                  headers: HeaderUtil.randomHeader(),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: black.withOpacity(0.2)),
          ),
          // 前景
          SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                // 模糊背景
                BlurryContainer(
                  borderRadius: BorderRadius.zero,
                  child: Container(),
                ),
                //
                Padding(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // AppBar Actions
                      widget.actionsWidget ?? const SizedBox(),
                      // 书籍标题和副标题
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 15.h, left: 15.w),
                          child: Stack(children: [
                            AspectRatio(
                              aspectRatio: 3 / 4,
                              child: Container(
                                key: _key1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.r),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      widget.cover ?? "",
                                      headers: HeaderUtil.randomHeader(),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: _titleLeft ?? 0),
                              child: _getTitlesUI(context),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 封面、标题和副标题
  Widget _getTitlesUI(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 书籍标题
          Text(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            widget.title ?? "",
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimary),
          ),

          6.verticalSpace,

          // 副标题
          Text(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            widget.subtitle ?? "",
            style: TextStyle(
              fontSize: 14.sp,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
