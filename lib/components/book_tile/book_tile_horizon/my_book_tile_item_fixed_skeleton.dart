import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class MyBookTileItemFixedSkeleton extends StatelessWidget {
  final bool? showRate;
  final double? width;
  final double? height;

  const MyBookTileItemFixedSkeleton(
      {super.key, this.showRate = true, this.width, this.height});

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
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),

          10.verticalSpace,

          // 书籍标题
          Container(
            width: width,
            height: 20.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),

          5.verticalSpace,

          // 书籍副标题、评分
          Container(
            width: width == null ? null : width! - 20,
            height: 18.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),

          showRate == true
              ? Container(
                  width: width == null ? null : width! - 20,
                  height: 20.h,
                  padding: EdgeInsets.only(top: 10.h),
                  child: Row(children: [
                    iconStar,
                    iconStar,
                    iconStar,
                    iconStar,
                    iconStar
                  ]),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
