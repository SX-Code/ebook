import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class MyBookActivitiesSkeleton extends StatelessWidget {
  const MyBookActivitiesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        '读书活动',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      10.verticalSpace,
      Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.inverseSurface,
        highlightColor: Theme.of(context).colorScheme.onInverseSurface,
        child: Container(
          height: 150.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
        ),
      )
    ]);
  }
}
