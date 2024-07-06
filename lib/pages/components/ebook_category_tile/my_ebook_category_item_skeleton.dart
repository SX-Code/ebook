import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class MyEBookCategoryItemSkeleton extends StatelessWidget {
  const MyEBookCategoryItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.inverseSurface,
      highlightColor: Theme.of(context).colorScheme.onInverseSurface,
      child: Padding(
        padding: EdgeInsets.only(top: 5.h, right: 15.w),
        child: Container(
          width: 80,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
        ),
      ),
    );
  }
}
