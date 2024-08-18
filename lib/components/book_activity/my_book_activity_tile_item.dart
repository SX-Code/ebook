import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_book_clone/models/book_activity.dart';
import 'package:e_book_clone/utils/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyBookActivityTileItem extends StatelessWidget {
  final BookActivity bookActivity;

  const MyBookActivityTileItem({super.key, required this.bookActivity});

  @override
  Widget build(BuildContext context) {
    return // 图片
        Stack(
      children: [
        Container(
          width: double.infinity,
          height: 150.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            image: DecorationImage(
              image: CachedNetworkImageProvider(bookActivity.bg ?? "",
                  headers: HeaderUtil.randomHeader()),
              fit: BoxFit.cover,
            ),
          ),
        ),

        Container(
          width: double.infinity,
          height: 150.h,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),

        // 活动标题
        Container(
          height: 150.h,
          padding: EdgeInsets.only(
            left: 15.w,
            top: 20.h,
            right: bookActivity.label == '共读交流' ? 100.w : 60.w,
            bottom: 15.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 题目
              Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                bookActivity.title ?? "",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // 专题、时间
              Row(
                children: [
                  // 专题
                  Container(
                    padding: EdgeInsets.all(5.r),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      bookActivity.label ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  10.horizontalSpace,

                  // 时间
                  Text(
                    bookActivity.time ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )
            ],
          ),
        ),

        // 右边
        bookActivity.label != '共读交流'
            ? const SizedBox()
            : Positioned(
                right: 18.w,
                bottom: 25.h,
                child: Container(
                  height: 100.h,
                  width: 70.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          bookActivity.bg ?? "",
                          headers: HeaderUtil.randomHeader(),
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
      ],
    );
  }
}
