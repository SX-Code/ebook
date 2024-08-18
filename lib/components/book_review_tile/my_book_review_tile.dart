import 'package:e_book_clone/components/book_review_tile/my_book_review_tile_item.dart';
import 'package:e_book_clone/components/book_review_tile/my_book_review_tile_item_skeleton.dart';
import 'package:e_book_clone/models/review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyBookReviewTile extends StatelessWidget {
  final List<Review>? reviews;
  const MyBookReviewTile({super.key, this.reviews});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '书评',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),

        15.verticalSpace,

        // 评论数据
        Column(
          children: List.generate(
            reviews?.length ?? 2,
            (index) {
              if (reviews == null) {
                // 骨架屏
                return const MyBookReviewTileItemSkeleton();
              } else {
                return MyBookReviewTileItem(review: reviews![index]);
              }
            },
          ),
        )
      ],
    );
  }
}
