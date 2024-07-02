import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_book_demo/utils/header_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyBookDetailAppbar extends StatefulWidget {
  final Widget? topActions;
  final String cover;
  final String title;
  final String subtitle;
  const MyBookDetailAppbar({
    super.key,
    this.topActions,
    required this.cover,
    required this.title,
    required this.subtitle,
  });

  @override
  State<MyBookDetailAppbar> createState() => _MyBookDetailAppbarState();
}

class _MyBookDetailAppbarState extends State<MyBookDetailAppbar> {
  final GlobalKey _key = GlobalKey();
  double? _coverWidth; // 封面的宽度

  @override
  Widget build(BuildContext context) {
    // 监听widget渲染完成
    WidgetsBinding.instance.addPersistentFrameCallback((duration) {
      RenderBox? box = _key.currentContext?.findRenderObject() as RenderBox?;
      if (_coverWidth == null) {
        _coverWidth = box?.size.width;
        // 通知组件更新
        setState(() {});
      }
    });
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false, // 不生产返回图标
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: Stack(
        children: [
          // 背景封面
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    widget.cover,
                    headers: HeaderUtil.randomHeader(),
                  ),
                  fit: BoxFit.cover),
            ),
          ),

          // 遮罩
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
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

                Padding(
                  // 安全区域的高度
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // leading、actions
                      widget.topActions ?? const SizedBox(),

                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: 15.h,
                            left: 15.w,
                          ),
                          child: Stack(
                            children: [
                              // 书籍封面，尽可能高度最大，控制比例，高宽自适应
                              AspectRatio(
                                aspectRatio: 3 / 4,
                                child: Container(
                                  key: _key,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.r),
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          widget.cover,
                                          headers: HeaderUtil.randomHeader(),
                                        ),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(left: _coverWidth ?? 0),
                                child: _getTitleUI(),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _getTitleUI() {
    return Padding(
      padding: EdgeInsets.only(left: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 书籍标题
          Text(
            widget.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),

          6.verticalSpace,
          // 书籍副标题
          Text(
            widget.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
