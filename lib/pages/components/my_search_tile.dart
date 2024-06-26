import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

class MySearchTile extends StatelessWidget {
  final VoidCallback? bookshelfTap;
  const MySearchTile({super.key, this.bookshelfTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 搜索框
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 15.w),
            height: 40.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              '搜索..',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 15.sp,
              ),
            ),
          ),
        ),
        // 书架图标
        Container(
          padding: EdgeInsets.only(left: 10.w),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: bookshelfTap,
            icon: Icon(
              LineIcons.stream,
              size: 25.r,
            ),
          ),
        )
      ],
    );
  }
}
