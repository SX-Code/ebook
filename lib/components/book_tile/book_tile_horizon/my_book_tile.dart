import 'package:e_book_clone/components/book_tile/book_tile_horizon/my_book_tile_item_fixed.dart';
import 'package:e_book_clone/components/book_tile/book_tile_horizon/my_book_tile_item_fixed_skeleton.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:e_book_clone/utils/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyBookTile extends StatelessWidget {
  final String? label;
  final List<Book>? books;
  final bool? showFav;
  final bool? showRate;
  final bool showMore;
  final bool? showAuthor;
  final double? height;
  final double? width;
  final bool? isProgress;
  final Function(Book)? itemTap;
  final VoidCallback? moreTap;

  const MyBookTile({
    super.key,
    required this.books,
    this.itemTap,
    this.label,
    this.moreTap,
    this.showMore = true,
    this.showFav = false,
    this.showRate,
    this.showAuthor,
    this.height,
    this.width,
    this.isProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label ?? "",
              style: MyDesign.styleTileTile,
            ),
            // 图书列表
            showMore == false
                ? const SizedBox()
                : GestureDetector(
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

        // 图书列表
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(books?.length ?? 4, (index) {
              if (books == null) {
                return Padding(
                  padding: EdgeInsets.only(right: 15.w),
                  child: MyBookTileItemFixedSkeleton(
                    width: width ?? 120.w,
                    height: height ?? 160.h,
                    showRate: showRate,
                  ),
                );
              }
              return GestureDetector(
                onTap: () {
                  if (books![index].id != null) {
                    itemTap?.call(books![index]);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 15.w),
                  child: MyBookTileItemFixed(
                    book: books![index],
                    width: width ?? 120.w,
                    height: height ?? 160.h,
                    showAuthor: showAuthor,
                    showFav: showFav,
                    showRate: showRate,
                    isProgress: isProgress,
                  ),
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}
