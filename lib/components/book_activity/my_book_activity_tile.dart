import 'package:e_book_clone/components/book_activity/my_book_activity_item_skeleton.dart';
import 'package:e_book_clone/components/book_activity/my_book_activity_tile_item.dart';
import 'package:e_book_clone/models/book_activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';

class MyBookActivityTile extends StatelessWidget {
  final String title;
  final VoidCallback? moreTap;
  final Function(String? url, String? title)? activityTap;
  final List<BookActivity>? bookActivities;

  const MyBookActivityTile(
      {super.key,
      this.title = '读书活动',
      required this.bookActivities,
      this.moreTap,
      this.activityTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),

          15.verticalSpace,

          // 活动卡片
          _getActivityCardUI(),
        ],
      ),
    );
  }

  Widget _getActivityCardUI() {
    if (bookActivities != null) {
      return SizedBox(
        width: double.infinity,
        height: 150.h,
        child: Swiper(
          autoplay: true,
          autoplayDelay: 10000,
          itemCount: bookActivities!.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => activityTap?.call(
                  bookActivities![index].url, bookActivities![index].title),
              child: MyBookActivityTileItem(
                bookActivity: bookActivities![index],
              ),
            );
          },
          pagination: SwiperPagination(
            alignment: Alignment.bottomRight,
            builder: DotSwiperPaginationBuilder(
                color: Colors.white.withOpacity(0.4),
                activeColor: Colors.white,
                size: 8.0,
                activeSize: 10.0,
                space: 2.0),
          ),
        ),
      );
    } else {
      return const MyBookActivityItemSkeleton();
    }
  }
}
