import 'package:e_book_clone/utils/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class MyBookTileVerticalItemSkeleton extends StatelessWidget {
  final double width;
  final double height;

  const MyBookTileVerticalItemSkeleton(
      {super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    Widget iconStar = Icon(Icons.star, size: 16.r);
    return Padding(
      padding: EdgeInsets.only(bottom: MyDesign.heightPageMargin),
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.inverseSurface,
        highlightColor: Theme.of(context).colorScheme.onInverseSurface,
        child: Row(
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inverseSurface,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            MyDesign.spaceHImageText,
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 书籍标题
                  Container(
                    height: 20.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),

                  MyDesign.spaceVTileTitle,

                  // 书籍副标题、评分
                  Container(
                    margin: const EdgeInsets.only(right: 100),
                    height: 18.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),

                  MyDesign.spaceVTileTitle,
                  // 星级
                  Container(
                    width: width,
                    height: 20.h,
                    padding: EdgeInsets.only(top: 10.h),
                    child: Row(children: [
                      iconStar,
                      iconStar,
                      iconStar,
                      iconStar,
                      iconStar
                    ]),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
