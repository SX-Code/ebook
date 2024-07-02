import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_book_demo/utils/header_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyBookReviewTileItem extends StatelessWidget {
  final String review;
  const MyBookReviewTileItem({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 20.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 作者信息
          Row(
            children: [
              // 头像
              ClipOval(
                child: CachedNetworkImage(
                  height: 40.r,
                  width: 40.r,
                  fit: BoxFit.cover,
                  imageUrl:
                      'https://img1.doubanio.com/view/personage/m/public/5502f513f32ae0f2c7e6422ba09c4478.jpg',
                  httpHeaders: HeaderUtil.randomHeader(),
                ),
              ),

              10.horizontalSpace,

              // 名称, 评分
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 名称
                  Text(
                    '螺丝',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // 评分
                  RatingBar.builder(
                    itemCount: 5,
                    ignoreGestures: true, // 只显示，不予响应
                    initialRating: (9.8) / 2,
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
              )
            ],
          ),
          10.verticalSpace,
          // 作者评论
          Text(
            review,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
