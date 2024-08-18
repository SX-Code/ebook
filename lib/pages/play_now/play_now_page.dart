import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_book_clone/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayNowPage extends StatefulWidget {
  final String? img;
  final String? title;
  final String? subTitle;

  const PlayNowPage({super.key, this.img, this.title, this.subTitle});

  @override
  State<PlayNowPage> createState() => _PlayNowPageState();
}

class _PlayNowPageState extends State<PlayNowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: _getAppBar(),
      ),
      body: _getBody(),
    );
  }

  Widget _getAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios_new,
          size: 20.r,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.more_horiz, size: 28.r),
        )
      ],
      title: Text(
        "播放中",
        style: TextStyle(fontSize: 18.sp),
      ),
    );
  }

  Widget _getBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(15.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 500.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  blurRadius: 15.r,
                  spreadRadius: 5.r,
                  color: black.withOpacity(0.05),
                  offset: const Offset(0, 10),
                )
              ],
              image: DecorationImage(
                image: CachedNetworkImageProvider(widget.img ?? ""),
                fit: BoxFit.cover,
              ),
            ),
          ),

          30.verticalSpace,

          //
          Text(
            widget.title ?? "",
            style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
          ),

          8.verticalSpace,

          //
          Text(
            widget.subTitle ?? "",
            style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          30.verticalSpace,
          // 播放进度条
          Stack(
            children: [
              Container(
                height: 4.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color: Theme.of(context)
                      .colorScheme
                      .inversePrimary
                      .withOpacity(0.3),
                ),
              ),
              Container(
                width: 150.w,
                height: 4.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            ],
          ),

          10.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '00:34:15',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              Text(
                '05:34:15',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              )
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 34.r,
                onPressed: () {},
                icon: Icon(
                  Icons.skip_previous_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              25.horizontalSpace,
              IconButton.filled(
                iconSize: 34.r,
                color: Colors.white,
                onPressed: () {},
                icon: const Icon(Icons.play_arrow),
              ),
              25.horizontalSpace,
              IconButton(
                iconSize: 34.r,
                onPressed: () {},
                icon: Icon(
                  Icons.skip_next_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
