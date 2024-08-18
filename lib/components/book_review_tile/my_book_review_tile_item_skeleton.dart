import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyBookReviewTileItemSkeleton extends StatelessWidget {
  const MyBookReviewTileItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget iconStar = Icon(Icons.star, size: 16.r, color: Theme.of(context).colorScheme.inverseSurface,);
    final Widget line = Container(
      width: double.infinity,
      height: 15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).colorScheme.inverseSurface,
      ),
    );

    final Widget shortLine = Container(
      width: 100.w,
      height: 15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).colorScheme.inverseSurface,
      ),
    );

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
              Container(
                height: 40.r,
                width: 40.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
              ),
              10.horizontalSpace,

              // 名称, 评分
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 名称
                  Container(
                    width:40.w,
                    height: 15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                  // 评分
                  SizedBox(
                    width: 80.w,
                    height: 20.h,
                    child: Row(children: List.generate(5, (_) {
                      return iconStar;
                    }),),
                  )
                ],
              )
            ],
          ),
          10.verticalSpace,
          // 作者评论
          Column(
            children: List.generate(5, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 7.h),
                child: line,
              );
            }),
          ),
          shortLine
        ],
      ),
    );
  }
}
