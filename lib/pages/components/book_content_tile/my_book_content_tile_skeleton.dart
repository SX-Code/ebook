import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class MyBookContentTileSkeleton extends StatelessWidget {
  const MyBookContentTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget line = Container(
      width: double.infinity,
      height: 15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).colorScheme.inverseSurface,
      ),
    );

    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.inverseSurface,
      highlightColor: Theme.of(context).colorScheme.onInverseSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Container(
            width: 80.w,
            height: 24.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),

          16.verticalSpace,

          // 内容
          Column(
            children: List.generate(8, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 7.h),
                child: line,
              );
            }),
          ),

          10.verticalSpace,

          // 更多信息
          Container(
            width: 60.w,
            height: 18.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),

          16.verticalSpace,

          Wrap(
            children: List.generate(3, (index) {
              return Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Container(
                  width: 80.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
