import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:e_book_clone/utils/design.dart';
import 'package:e_book_clone/utils/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

// 宽高确定的图书子组件
class MyBookTileItemFixed extends StatefulWidget {
  final Book book;
  final double? width;
  final double? height;
  final bool? showFav;
  final bool? showRate;
  final bool? onlyTitle;
  final bool? showAuthor;
  final bool? isProgress;

  const MyBookTileItemFixed(
      {super.key,
      required this.book,
      this.width,
      this.height,
      this.showFav = false,
      this.showRate = true,
      this.onlyTitle = false,
      this.showAuthor = false,
      this.isProgress = false});

  @override
  State<MyBookTileItemFixed> createState() => _MyBookTileItemFixedState();
}

class _MyBookTileItemFixedState extends State<MyBookTileItemFixed> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 封面、是否喜欢（收藏）、价格
        Stack(
          children: [
            // 封面
            Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    widget.book.cover ?? "",
                    headers: HeaderUtil.randomHeader(),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 是否喜欢
            _isShowFavUI(),

            _isShowPriceUI()
          ],
        ),

        Container(
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                widget.book.cover ?? "",
                headers: HeaderUtil.randomHeader(),
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // 书籍标题
        Container(
          padding: EdgeInsets.only(top: 10.h),
          width: widget.width,
          child: Text(
            widget.book.title ?? "",
            maxLines: 1,
            style: TextStyle(
                fontSize: MyDesign.fontSizeBookTitle,
                fontWeight: FontWeight.w500),
          ),
        ),

        // 书籍副标题
        _isShowSunTitle(),

        // 书籍评分
        _isShowRateUI(),

        // 阅读进度
        _isShowProgressUI(),
      ],
    );
  }

  Widget _isShowRateUI() {
    if (widget.showRate != true) {
      return const SizedBox();
    }
    return Container(
      margin: EdgeInsets.only(top: 6.h),
      width: widget.width,
      child: Row(
        // 星级
        children: [
          RatingBar.builder(
            itemCount: 5,
            ignoreGestures: true,
            initialRating: (widget.book.rate ?? 0.0) / 2,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemSize: 15.r,
            itemPadding: EdgeInsets.only(right: 2.w),
            itemBuilder: (context, _) {
              return Icon(
                Icons.star,
                color: Theme.of(context).colorScheme.tertiary,
              );
            },
            onRatingUpdate: (rating) {},
          ),

          // 分数
          Text(
            '(${widget.book.rate})',
            style: TextStyle(
              fontSize: 12.sp,
              height: 1.2,
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  Widget _isShowPriceUI() {
    if (widget.book.price == null) {
      return const SizedBox();
    }
    return Positioned(
      bottom: widget.height != null ? widget.height! / 3 : null,
      child: Container(
        width: 65.w,
        height: 25.h,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12.r),
              bottomRight: Radius.circular(12.r),
            )),
        child: Center(
          child: Text(
            '¥${widget.book.price}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _isShowFavUI() {
    if (widget.showFav == false) {
      return const SizedBox();
    }
    return Positioned(
      right: 8.w,
      top: 8.h,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: 24.w,
          height: 24.h,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle),
          child: Icon(
            widget.book.favourite == true
                ? LineIcons.heartAlt
                : LineIcons.heart,
            size: 16.r,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
    );
  }

  Widget _isShowSunTitle() {
    if (widget.onlyTitle == true) {
      return const SizedBox();
    }
    String? subtitle;
    if (widget.showAuthor == true) {
      subtitle = widget.book.authorName;
    } else {
      if (widget.book.subTitle == null) {
        subtitle = widget.book.authorName;
      } else {
        subtitle = widget.book.subTitle;
      }
    }

    if (subtitle == null || subtitle.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: EdgeInsets.only(top: 5.h),
      width: widget.width,
      child: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: MyDesign.fontSizeBookSubtitle,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }

  Widget _isShowProgressUI() {
    if (widget.isProgress != true) {
      return const SizedBox();
    } 
    double progress = widget.book.progress?.toDouble() ?? 0.0;
    return SizedBox(
      width: widget.width,
      child: Row(
        children: [
          Expanded(
            child: LinearProgressIndicator(
              value: progress / 100,
            ),
          ),
          5.horizontalSpace,
          Text('${progress.toInt()}%')
        ],
      ),
    );
  }
}
