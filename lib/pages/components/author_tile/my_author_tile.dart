import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_book_demo/pages/components/author_tile/my_author_tile_skeleton.dart';
import 'package:e_book_demo/utils/header_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAuthorTile extends StatelessWidget {
  final List? authors;
  const MyAuthorTile({super.key, this.authors});

  @override
  Widget build(BuildContext context) {
    if (authors == null) {
      // 骨架屏
      return const MyAuthorTileSkeleton();
    } else {
      return Column(
        children: List.generate(authors!.length, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 作者信息
                Row(
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        height: 40.r,
                        width: 40.r,
                        fit: BoxFit.cover,
                        imageUrl:
                            'https://img1.doubanio.com/view/personage/m/public/5502f513f32ae0f2c7e6422ba09c4478.jpg',
                        httpHeaders: HeaderUtil.randomHeader(),
                      ),
                    ),
                    10.horizontalSpace,
                    Column(
                      children: [
                        Text(
                          "罗新",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "作者",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        )
                      ],
                    )
                  ],
                ),
            
                // 了解作者
                Row(
                  children: [
                    Text(
                      '了解作者',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    3.horizontalSpace,
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14.r,
                    )
                  ],
                )
              ],
            ),
          );
        }),
      );
    }
  }
}
