import 'package:e_book_clone/http/spider/api_string.dart';
import 'package:e_book_clone/models/book.dart';
import 'package:e_book_clone/utils/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyEbbokCategoryTile extends StatelessWidget {
  final List<Category> categories;
  final Function(String url)? itemTap;

  const MyEbbokCategoryTile(
      {super.key, required this.categories, this.itemTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题
        Text(
          "图书标签",
          style: MyDesign.styleTileTile,
        ),

        // Column(
        //   children: List.generate(2, (index) {
        //     return SingleChildScrollView(
        //       scrollDirection: Axis.horizontal,
        //       child: Row(
        //         children: List.generate(genres.length, (index) {
        //           return Padding(
        //               padding: EdgeInsets.only(right: MyDesign.widthPageMargin),
        //               child: ActionChip(label: Text(genres[index])),
        //             );
        //         }),
        //       ),
        //     );
        //   }),
        // ),
        MyDesign.spaceVTileTitle,

        SizedBox(
          width: double.infinity,
          child: Wrap(
            children: List.generate(
              categories.length,
              (index) {
                return Padding(
                  padding: EdgeInsets.only(right: MyDesign.widthPageMargin),
                  child: ActionChip(
                      onPressed: () => itemTap?.call(
                          '${ApiString.ebookBaseUrl}${categories[index].url}'),
                      padding: EdgeInsets.all(2.r),
                      label: Text(categories[index].name ?? "")),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
