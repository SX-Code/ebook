import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAppBarActions extends StatelessWidget {
  final VoidCallback? bookmarkTap;
  final VoidCallback? headphoneTap;
  final VoidCallback? linkTap;

  const MyAppBarActions(
      {super.key, this.bookmarkTap, this.headphoneTap, this.linkTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 左侧返回图标
        IconButton(
          iconSize: 20.r,
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),

        // 右侧Actions
        Row(
          children: [
            IconButton(
              onPressed: bookmarkTap,
              tooltip: '加入书架',
              icon: Icon(
                  Icons.bookmark,
                  size: 20.r,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            IconButton(
              onPressed: headphoneTap,
              icon: Icon(
                Icons.headphones,
                size: 20.r,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            IconButton(
              onPressed: linkTap,
              tooltip: '在线阅读',
              icon: Icon(
                Icons.menu_book_rounded,
                size: 20.r,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        )
      ],
    );
  }
}
