import 'package:e_book_demo/model/ebook_category.dart';
import 'package:e_book_demo/pages/components/ebook_category_tile/my_ebook_category_item_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyEBookCategoryTile extends StatelessWidget {
  final List<EBookCategory>? categories;
  final String? title;
  final Function(EBookCategory category)? itemTap;
  const MyEBookCategoryTile(
      {super.key, this.categories, this.title, this.itemTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? "",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        15.verticalSpace,
        SizedBox(
          width: double.infinity,
          child: Wrap(
            children: List.generate(categories?.length ?? 12, (index) {
              if (categories == null) {
                return const MyEBookCategoryItemSkeleton();
              }
              return Padding(
                padding: EdgeInsets.only(right: 15.w),
                child: ActionChip(
                  onPressed: () {
                    itemTap?.call(categories![index]);
                  },
                  padding: EdgeInsets.all(2.r),
                  label: Text(categories![index].name ?? ""),
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}
