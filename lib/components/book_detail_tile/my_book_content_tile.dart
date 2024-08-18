import 'package:e_book_clone/components/book_detail_tile/my_book_content_tile_skeleton.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';

class MyBookContentTile extends StatelessWidget {
  final String title;
  final Book? book;
  final bool? showTags;
  final String? labelTitle;
  final Function(String? url)? storeItemTap;

  const MyBookContentTile(
      {super.key,
      this.title = '内容简介',
      required this.book,
      this.storeItemTap,
      this.showTags = false, 
      this.labelTitle});

  @override
  Widget build(BuildContext context) {
     if (book == null) {
      // 骨架屏
      return const MyBookContentTileSkeleton();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        15.verticalSpace,
        ReadMoreText(
          book?.description ?? "",
          trimLines: 8,
          trimCollapsedText: '更多',
          trimExpandedText: '收起',
          trimLength: 200,
          colorClickableText: Theme.of(context).colorScheme.primary,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
        
        15.verticalSpace,
        Text(
          labelTitle ?? "",
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),

        10.verticalSpace,

        // 购买信息
        _isShowTags()
      ],
    );
  }

  Widget _isShowTags() {
    if (showTags == true) {
      // 书籍标签信息
      return Wrap(
        children: List.generate(book?.tags?.length ?? 0, (index) {
          Tag? tag = book?.tags?[index];
          return Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: ActionChip(
              padding: EdgeInsets.all(2.r),
              label: Text(
                '${tag?.name} ${tag?.count}',
                style: TextStyle(fontSize: 12.sp),
              ),
              onPressed: () => storeItemTap?.call(tag?.url),
            ),
          );
        }),
      );
    }
    // 书籍购买途径信息
    return Wrap(
      children: List.generate(book?.buyInfo?.length ?? 0, (index) {
        BuyInfo? buyInfo = book?.buyInfo?[index];
        return Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: ActionChip(
            padding: EdgeInsets.all(2.r),
            label: Text(
              '${buyInfo?.name}: ¥${buyInfo?.price}',
              style: TextStyle(fontSize: 12.sp),
            ),
            onPressed: () => storeItemTap?.call(buyInfo?.url),
          ),
        );
      }),
    );
  }
}
