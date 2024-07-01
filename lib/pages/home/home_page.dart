import 'package:e_book_demo/model/activity.dart';
import 'package:e_book_demo/model/book.dart';
import 'package:e_book_demo/pages/components/book_tile/my_book_tile.dart';
import 'package:e_book_demo/pages/components/my_search_tile.dart';
import 'package:e_book_demo/pages/home/components/my_book_activities.dart';
import 'package:e_book_demo/pages/home/components/my_book_activities_skeleton.dart';
import 'package:e_book_demo/pages/home/components/my_book_activity_labels.dart';
import 'package:e_book_demo/pages/home/components/my_book_activity_labels_skeleton.dart';
import 'package:e_book_demo/pages/home/home_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeViewModel _viewModel = HomeViewModel();
  @override
  void initState() {
    super.initState();
    _viewModel.getHomePageData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _getBodyUI(),
    );
  }

  Widget _getBodyUI() {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      builder: (context, child) {
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
                Selector<HomeViewModel, List<Activity>?>(
                    builder: (context, List<Activity>? activities, child) {
                      if (activities == null) {
                        // 这里可以展示骨架屏
                        return const MyBookActivitiesSkeleton();
                      }
                      return MyBookActivities(activities: activities);
                    },
                    selector: (_, viewModel) => viewModel.activities),

                15.verticalSpace,

                // 活动类型
                Selector<HomeViewModel, List<String>?>(
                  builder: (context, labels, child) {
                    if (labels == null) {
                      // 骨架屏
                      return const MyBookActivityLabelsSkeleton();
                    }
                    return MyBookActivityLabels(
                      labels: labels,
                      itemTap: (index) {
                        int? kind = index == 0 ? null : index - 1;
                        _viewModel.getBookActivities(kind);
                      },
                    );
                  },
                  selector: (_, viewModel) => viewModel.activityLabels,
                ),

                30.verticalSpace,

                // 特别为您准备
                Selector<HomeViewModel, List<Book>?>(
                  builder: (context, books, child) {
                    return MyBookTile(
                      title: '特别为您准备',
                      books: books,
                      width: 120.w,
                      height: 160.h,
                    );
                  },
                  selector: (_, viewModel) => viewModel.books,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
