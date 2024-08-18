import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class MyBookTileItemAutoSkeleton extends StatelessWidget {
  final bool? showRate;

  const MyBookTileItemAutoSkeleton({super.key, this.showRate = true});

  @override
  Widget build(BuildContext context) {
    Widget iconStar = Icon(Icons.star, size: 16.r);
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.inverseSurface,
      highlightColor: Theme.of(context).colorScheme.onInverseSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 封面
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
          ),
          // 书籍标题
          Container(
            margin: EdgeInsets.only(top: 10.h),
            height: 20.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),

          // 书籍副标题、评分
          Container(
            margin: EdgeInsets.only(top: 5.h),
            height: 18.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),

          showRate == true
              ? Container(
                  height: 20.h,
                  margin: EdgeInsets.only(top: 10.h),
                  child: Row(children: [
                    iconStar,
                    iconStar,
                    iconStar,
                    iconStar,
                    iconStar
                  ]),
                )
              : SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
