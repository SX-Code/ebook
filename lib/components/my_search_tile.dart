import 'package:e_book_clone/user/user_provider.dart';
import 'package:e_book_clone/utils/navigator_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class MySearchTile extends StatelessWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final List<Widget>? addonIcon;
  final bool? showBookshelf;
  final VoidCallback? onTap;

  const MySearchTile(
      {super.key,
      required this.hintText,
      required this.textEditingController,
      this.addonIcon,
      this.showBookshelf,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: IntrinsicWidth(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 15.w),
                  height: 40.h,
                  // width: 100.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '搜索..',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 14.sp,
                    ),
                  )

                  // TextField(
                  //   autofocus: false,
                  //   decoration: InputDecoration(
                  //     isCollapsed: true,
                  //     contentPadding:
                  //         EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                  //     border: InputBorder.none,
                  //     hintText: hintText,
                  //   ),
                  // ),
                  ),
            ),
          ),
        ),
        showBookshelf == false
            ? const SizedBox()
            : Container(
                padding: EdgeInsets.only(left: 10.w),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  tooltip: '我的书架',
                  onPressed: () {
                    NavigatorUtils.nav2Bookshelf(
                      context,
                      Provider.of<UserProvider>(context, listen: false)
                          .userInfo
                          ?.id,
                    );
                  },
                  icon: Icon(LineIcons.stream, size: 25.r),
                ),
              ),
        Row(
          children: List.generate(addonIcon?.length ?? 0, (index) {
            if (addonIcon != null && addonIcon!.isNotEmpty) {
              return addonIcon![index];
            }
            return const SizedBox();
          }),
        )
      ],
    );
  }
}
