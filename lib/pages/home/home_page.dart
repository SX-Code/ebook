import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_book_demo/pages/components/my_book_tile.dart';
import 'package:e_book_demo/pages/components/my_search_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _value = 0;
  List<String> activities = [
    "全部",
    "读书专题",
    "直播活动",
    "名家问答",
    "共读交流",
    "鉴书团",
  ];
  List<String> images = [
    "https://img3.doubanio.com/mpic/book-activity-5f72c3983c7545c1910cfd569c2c4a82",
    "https://img1.doubanio.com/mpic/book-activity-9c35a73f74604f7fb3776f1864364489",
    "https://img3.doubanio.com/mpic/book-activity-5f72c3983c7545c1910cfd569c2c4a82",
    "https://img1.doubanio.com/mpic/book-activity-9c35a73f74604f7fb3776f1864364489",
  ];
  List<Map<String, dynamic>> books = [
    {
      "title": "食南之徒",
      "authorName": '马伯庸',
      "cover": 'https://img3.doubanio.com/view/subject/s/public/s34823157.jpg'
    },
    {
      "title": "赎罪",
      "authorName": '[日] 凑佳苗',
      "cover": 'https://img1.doubanio.com/view/subject/s/public/s34853929.jpg'
    },
    {
      "title": "八月我们相见",
      "authorName": '哥伦比亚]加西亚·马尔克斯',
      "cover": 'https://img1.doubanio.com/view/subject/s/public/s34797230.jpg'
    },
    {
      "title": "八月我们相见",
      "authorName": '哥伦比亚]加西亚·马尔克斯',
      "cover": 'https://img1.doubanio.com/view/subject/s/public/s34797230.jpg'
    },
    {
      "title": "八月我们相见",
      "authorName": '哥伦比亚]加西亚·马尔克斯',
      "cover": 'https://img1.doubanio.com/view/subject/s/public/s34797230.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _getBodyUI(),
    );
  }

  Widget _getBodyUI() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(15.r),
        child: Column(
          children: [
            10.verticalSpace,
            // SizedBox(height: 10.h,),
            // 头像
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '您好，豆瓣',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // 头像
                const CircleAvatar(
                  backgroundImage: AssetImage('images/avatar.png'),
                )
              ],
            ),

            15.verticalSpace,

            // 搜索
            MySearchTile(
              bookshelfTap: () {},
            ),

            30.verticalSpace,

            // 读书活动
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '读书活动',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                10.verticalSpace,
                SizedBox(
                  height: 150.h,
                  width: double.infinity,
                  child: Swiper(
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          // 背景图
                          Container(
                            width: double.infinity,
                            height: 150.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    images[index],
                                    headers: const {
                                      'User-Agent':
                                          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Safari/605.1.15'
                                    },
                                  ),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          // 背景
                          Container(
                            width: double.infinity,
                            height: 150.h,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          // 文字
                          Container(
                            height: 150.h,
                            padding: EdgeInsets.all(15.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // 标题
                                Text(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  "眺望山峦，或凝视虚空：卡夫卡逝世百年纪念对谈｜阿乙×李双志×包慧怡",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                // 专题、时间
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5.r),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(4.r),
                                      ),
                                      child: const Text(
                                        "读书专题",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    10.horizontalSpace,

                                    // 时间
                                    const Text(
                                      "2024-05-31 - 06-10",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
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
                )
              ],
            ),

            15.verticalSpace,

            // 活动类型
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '活动类型',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  5.verticalSpace,
                  Wrap(
                    children: List.generate(activities.length, (index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: ChoiceChip(
                          label: Text(activities[index]),
                          selected: _value == index,
                          onSelected: (value) {
                            setState(() {
                              _value = index;
                            });
                          },
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),

            30.verticalSpace,

            // 特别为您准备
            MyBookTile(
              books: books,
              width: 120.w,
              height: 160.h,
            ),
          ],
        ),
      ),
    );
  }
}
