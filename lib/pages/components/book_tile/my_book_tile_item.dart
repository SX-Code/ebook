import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_book_demo/model/book.dart';
import 'package:e_book_demo/utils/header_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyBookTileItem extends StatelessWidget {
  final Book book;
  final double? width;
  final double? height;
  final bool? showPrice;
  final bool? showRate;
  const MyBookTileItem(
      {super.key,
      required this.book,
      this.height,
      this.width,
      this.showPrice,
      this.showRate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // 封面
              Container(
                width: width,
                height: height,
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

              // 价格，灵活显示
              _getPriceUI(context),
            ],
          ),
          // 标题
          Container(
            padding: EdgeInsets.only(top: 10.h),
            width: width,
            child: Text(
              maxLines: 1,
              book.title ?? "",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // 副标题
          _getSubTitleUI(context),

          // 评分
          _getRateUI(),
        ],
      ),
    );
  }

  Widget _getSubTitleUI(BuildContext context) {
    if (book.subTitle == null && book.authorName == null) {
      return const SizedBox();
    }
    return Container(
      padding: EdgeInsets.only(top: 5.h),
      width: width,
      child: Text(
        maxLines: 1,
        book.subTitle ?? book.authorName ?? "",
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }

  Widget _getRateUI() {
    if (showRate != true) {
      return const SizedBox();
    }
    return Container(
      margin: EdgeInsets.only(top: 6.h),
      width: width,
      child: Row(
        children: [
          RatingBar.builder(
            itemCount: 5,
            ignoreGestures: true, // 只显示，不予响应
            initialRating: (book.rate ?? 0.0) / 2,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true, // 半星
            itemPadding: EdgeInsets.only(right: 2.w),
            itemSize: 15.r,
            itemBuilder: (context, _) {
              return Icon(
                Icons.star,
                color: Theme.of(context).colorScheme.tertiary,
              );
            },
            onRatingUpdate: (rating) {},
          ),
        ],
      ),
    );
  }

  Widget _getPriceUI(BuildContext context) {
    if (showPrice == false) {
      return const SizedBox();
    }
    return Positioned(
      bottom: height == null ? 20 : height! / 3,
      child: Container(
        width: 65.w,
        height: 25.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12.r),
            bottomRight: Radius.circular(12.r),
          ),
        ),
        child: Center(
          child: Text(
            '¥12.0',
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
}
