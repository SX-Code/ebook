import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class MyBookActivityTypeTileSkeleton extends StatelessWidget {
  final String title;
  const MyBookActivityTypeTileSkeleton({super.key, this.title = '活动类型'});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
          ),
          10.verticalSpace,
          Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.inverseSurface,
            highlightColor: Theme.of(context).colorScheme.onInverseSurface,
            child: Wrap(
              children: List.generate(6, (index) {
                return Padding(
                  padding: EdgeInsets.only(right: 10.w, bottom: 8.h),
                  child: Container(
                    height: 40.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.inverseSurface,
                        borderRadius: BorderRadius.circular(8.r)),
                    padding:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
