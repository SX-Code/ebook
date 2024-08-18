import 'package:e_book_clone/utils/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class MyEbbokCategoryTileSkeleton extends StatelessWidget {
  const MyEbbokCategoryTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget storeItem = Container(
      width: 80,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.inverseSurface,
      ),
    );

    return Column(
      children: [
        // 标题
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "图书标签",
              style: MyDesign.styleTileTile,
            ),
            // 图书列表
            GestureDetector(
              child: Row(
                children: [
                  Text('更多', style: TextStyle(fontSize: 12.sp)),
                  3.horizontalSpace,
                  Icon(Icons.arrow_forward_ios, size: 14.r),
                ],
              ),
            ),
          ],
        ),

        MyDesign.spaceVTileTitle,
        Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.inverseSurface,
          highlightColor: Theme.of(context).colorScheme.onInverseSurface,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 5.h),
            child: Wrap(
              runSpacing: MyDesign.widthPageMargin,
              children: List.generate(12, (_) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: storeItem,
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
