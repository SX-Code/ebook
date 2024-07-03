import 'package:e_book_demo/model/book.dart';
import 'package:e_book_demo/pages/components/book_content_tile/my_book_content_tile_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';

class MyBookContentTile extends StatelessWidget {
  final Book? book;
  final String? labelTitle;
  const MyBookContentTile({super.key, this.book, this.labelTitle});

  @override
  Widget build(BuildContext context) {
    if (book == null) {
      // 骨架屏
      return const MyBookContentTileSkeleton();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Text(
            "内容简介",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          15.verticalSpace,

          // 内容
          ReadMoreText(
            book?.description ?? "",
            trimLines: 8, // 显示的行数
            trimLength: 200, // 显示的字数
            trimCollapsedText: '更多',
            trimExpandedText: '收起',
            colorClickableText: Theme.of(context).colorScheme.primary,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              height: 1.5, // 行高
            ),
          ),

          10.verticalSpace,

          // 更多信息
          Text(
            labelTitle ?? "",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          10.verticalSpace,

          Wrap(
              children: List.generate(book!.buyInfo?.length ?? 0, (index) {
            return Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: ActionChip(
                label: Text(
                  '${book!.buyInfo?[index].name}: ¥${book!.buyInfo?[index].price}',
                  style: TextStyle(fontSize: 12.sp),
                ),
                onPressed: () {},
              ),
            );
          }))
        ],
      );
    }
  }
}
