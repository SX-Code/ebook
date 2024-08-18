import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class MyBookActivityItemSkeleton extends StatelessWidget {
  const MyBookActivityItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.inverseSurface,
      highlightColor: Theme.of(context).colorScheme.onInverseSurface,
      child: Container(
        width: double.infinity,
        height: 150.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: Theme.of(context).colorScheme.inverseSurface,
        ),
      ),
    );
  }
}
