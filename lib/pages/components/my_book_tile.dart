import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyBookTile extends StatelessWidget {
  final List<Map> books;
  final double? height;
  final double? width;
  const MyBookTile({
    super.key,
    required this.books,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return // 特别为您准备
        Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '特别为您准备',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),

        15.verticalSpace,

        // 书籍信息
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(books.length, (index) {
              return Padding(
                padding: EdgeInsets.only(right: 15.w),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        // 封面
                        Container(
                          width: width,
                          height: height,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  books[index]['cover'] ?? "",
                                  headers: const {
                                    "User-Agent":
                                        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Safari/605.1.15"
                                  }),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // 价格，灵活显示
                        Positioned(
                          bottom: height == null ? 20 : height! / 3,
                          child: Container(
                            width: 65.w,
                            height: 25.h,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12.r),
                                bottomRight: Radius.circular(12.r),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '¥12.0',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // 标题
                    Container(
                      padding: EdgeInsets.only(top: 10.h),
                      width: width,
                      child: Text(
                        maxLines: 1,
                        books[index]['title'] ?? "",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // 副标题
                    Container(
                      padding: EdgeInsets.only(top: 5.h),
                      width: width,
                      child: Text(
                        maxLines: 1,
                        books[index]['authorName'] ?? "",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}
