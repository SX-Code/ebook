import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:e_book_clone/utils/design.dart';
import 'package:e_book_clone/utils/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

// 高度自适应的图书子项，适用于GridView
class MyBookTileItemAuto extends StatelessWidget {
  final Book book;
  final bool? showFav;
  final bool? showRate;
  final bool? onlyTitle;
  final bool? showAuthor;

  const MyBookTileItemAuto(
      {super.key,
      required this.book,
      this.showFav = true,
      this.showRate = true,
      this.onlyTitle = false,
      this.showAuthor = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 封面、是否喜欢（收藏）、价格
        Expanded(
          child: Stack(
            children: [
              // 封面
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      book.cover ?? "",
                      headers: HeaderUtil.randomHeader(),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // 喜欢
              _isShowFavUI(context),

              // 价格
              _isShowPriceUI(context)
            ],
          ),
        ),

        // 书籍标题
        Container( 
          padding: EdgeInsets.only(top: 10.h),
          child: Text(
            book.title ?? "",
            maxLines: 1,
            style: TextStyle(
                fontSize: MyDesign.fontSizeBookTitle,
                fontWeight: FontWeight.w500),
          ),
        ),

        // 书籍副标题
        _isShowSunTitle(context),

        // 书籍评分
        _isShowRateUI(context),
      ],
    );
  }

  Widget _isShowRateUI(BuildContext context) {
    if (showRate != true) {
      return SizedBox(height: 20.h);
    }
    return Container(
      margin: EdgeInsets.only(top: 6.h),
      child: Wrap(
        // 星级
        children: [
          RatingBar.builder(
            itemCount: 5,
            ignoreGestures: true,
            initialRating: (book.rate ?? 0.0) / 2,
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
            '(${book.rate})',
            style: TextStyle(
              fontSize: 12.sp,
              overflow: TextOverflow.ellipsis,
              height: 1.2,
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  Widget _isShowPriceUI(BuildContext context) {
    if (book.price == null) {
      return const SizedBox();
    }
    return Align(
      alignment: Alignment.centerLeft,
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
            '¥${book.price}',
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

  Widget _isShowFavUI(BuildContext context) {
    if (showFav == false) {
      return const SizedBox();
    }
    return Positioned(
      right: 8.w,
      top: 8.h,
      child: GestureDetector(
        onTap: () {
        },
        child: Container(
          width: 24.w,
          height: 24.h,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle),
          child: Icon(
            book.favourite == true ? LineIcons.heartAlt : LineIcons.heart,
            size: 16.r,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
    );
  }

  Widget _isShowSunTitle(BuildContext context) {
    if (onlyTitle == true) {
      return const SizedBox();
    }
    String? subtitle;
    if (showAuthor == true) {
      subtitle = book.authorName;
    } else {
      if (book.subTitle == null) {
        subtitle = book.authorName;
      } else {
        subtitle = book.subTitle;
      }
    }

    if (subtitle == null || subtitle.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: EdgeInsets.only(top: 5.h),
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
}
