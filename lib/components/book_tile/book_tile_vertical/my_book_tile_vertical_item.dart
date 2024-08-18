import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:e_book_clone/utils/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyBookTileVerticalItem extends StatelessWidget {
  final double? width;
  final double? height;
  final Book book;
  final Function(String id)? onTap;

  const MyBookTileVerticalItem(
      {super.key, required this.book, this.width, this.height, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MyDesign.heightPageMargin),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap?.call(book.id ?? ""),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: width ?? 80.w,
                height: height ?? 105.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      book.cover ?? "",
                    ),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              MyDesign.spaceHImageText,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title ?? "",
                          style: MyDesign.styleBookTitle,
                        ),
                        MyDesign.spaceVTextText,
                        Text(
                          book.authorName ?? book.subTitle ?? "",
                          style: TextStyle(
                            fontSize: MyDesign.fontSizeBookSubtitle,
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                          
                    // 描述
                    _getDescUI(context),
                          
                    // 评分
                    _getRateUI(context),
                          
                    // 字数
                    _getWordCount(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getRateUI(BuildContext context) {
    if (book.rate == null) {
      return const SizedBox();
    }
    return Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: Row(
          // 星级
          children: [
            RatingBar.builder(
              itemCount: 5,
              ignoreGestures: true,
              initialRating: (book.rate ?? 0.0) / 2,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemSize: 15.r,
              itemPadding: EdgeInsets.only(right: 2.w),
              itemBuilder: (context, _) {
                return Icon(
                  Icons.star,
                  color: Theme.of(context).colorScheme.tertiary,
                );
              },
              onRatingUpdate: (rating) {},
            ),

            // 分数
            Text(
              '(${book.rate})',
              style: TextStyle(
                fontSize: 12.sp,
                height: 1.1,
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ));
  }

  Widget _getWordCount(BuildContext context) {
    Color fontColor = Theme.of(context).colorScheme.inversePrimary;
    return Row(
      children: [
        Text(
          book.kind ?? '图书',
          style: TextStyle(
            color: fontColor,
            fontSize: MyDesign.fontSizeBookSubtitle,
          ),
        ),
        Container(
          width: 1,
          height: 11,
          margin: EdgeInsets.only(left: 8.w, right: 8.w),
          color: fontColor.withOpacity(0.5),
        ),
        Text(
          '${book.labelCount ?? 0} 字',
          style: TextStyle(
            color: fontColor,
            fontSize: MyDesign.fontSizeBookSubtitle,
          ),
        ),
      ],
    );
  }

  Widget _getDescUI(BuildContext context) {
    return Text(
      book.description ?? "",
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
