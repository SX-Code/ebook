import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class MyBookDetailTileSkeleton extends StatelessWidget {
  final String label;
  const MyBookDetailTileSkeleton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.inverseSurface,
            highlightColor: Theme.of(context).colorScheme.onInverseSurface,
            child: Container(
              width: 40.w,
              height: 20.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                color: Theme.of(context).colorScheme.onInverseSurface,
              ),
            ),
          ),
          8.verticalSpace,
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ],
      ),
    );
  }
}
