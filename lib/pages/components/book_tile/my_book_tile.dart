import 'package:e_book_demo/model/book.dart';
import 'package:e_book_demo/pages/components/book_tile/my_book_tile_item.dart';
import 'package:e_book_demo/pages/components/book_tile/my_book_tile_item_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyBookTile extends StatelessWidget {
  final List<Book>? books;
  final double? height;
  final double? width;
  final bool? showPrice;
  final String title;
  final bool? showRate;
  const MyBookTile({
    super.key,
    required this.books,
    this.height,
    this.width,
    this.showPrice = false,
    required this.title,
    this.showRate,
  });

  @override
  Widget build(BuildContext context) {
    // 特别为您准备
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),

        15.verticalSpace,

        // 书籍信息
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(books?.length ?? 5, (index) {
              if (books == null) {
                // 骨架屏
                return MyBookTileItemSkeleton(
                  width: width,
                  height: height,
                );
              }
              return MyBookTileItem(
                book: books![index],
                width: width,
                height: height,
                showRate: showRate,
                showPrice: showPrice,
              );
            }),
          ),
        )
      ],
    );
  }
}
