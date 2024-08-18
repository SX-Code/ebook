import 'package:e_book_clone/components/book_tile/book_tile_vertical/my_book_tile_vertical_item.dart';
import 'package:e_book_clone/components/book_tile/book_tile_vertical/my_book_tile_vertical_item_skeleton.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:e_book_clone/utils/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyBookTileVertical extends StatelessWidget {
  final Function(String bookId)? bookItemTap;
  final String? label;
  final List<Book>? books;
  final VoidCallback? moreTap;

  const MyBookTileVertical({
    super.key,
    this.books,
    this.bookItemTap,
    this.label,
    this.moreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label ?? "",
              style: MyDesign.styleTileTile,
            ),
            // 图书列表
            GestureDetector(
              onTap: moreTap,
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
        15.verticalSpace,
        Column(
          children: List.generate(books?.length ?? 5, (index) {
            if (books == null) {
              // 骨架
              return MyBookTileVerticalItemSkeleton(
                width: 80.w,
                height: 105.h,
              );
            }
            return MyBookTileVerticalItem(
              width: 80.w,
              height: 105.h,
              book: books![index],
              onTap: bookItemTap,
            );
          }),
        )
      ],
    );
  }
}
