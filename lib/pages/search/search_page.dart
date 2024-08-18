import 'package:e_book_clone/models/suggest.dart';
import 'package:e_book_clone/pages/search/my_search_delegate.dart';
import 'package:e_book_clone/pages/search/search_result_page.dart';
import 'package:e_book_clone/pages/search/search_vm.dart';
import 'package:e_book_clone/utils/log_utils.dart';
import 'package:e_book_clone/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// https://www.cnblogs.com/yongfengnice/p/14143805.html
/// 详细的textfield设置
class SearchPage extends MySearchDelegate {
  final SearchViewModel _viewModel = SearchViewModel();

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        systemOverlayStyle: colorScheme.brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        titleSpacing: 0,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        isCollapsed: true,
        hintStyle: TextStyle(
            color: Theme.of(ToastUtils.context).colorScheme.inversePrimary),
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        fillColor: Theme.of(context).colorScheme.secondary,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
      ),
    );
  }

  @override
  TextStyle? get searchFieldStyle => TextStyle(fontSize: 14.sp);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Padding(
        padding: EdgeInsets.only(right: 15.w, left: 15.w),
        child: GestureDetector(
          onTap: () {
            showResults(context);
          },
          child: Text(
            '搜索',
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary, fontSize: 15.sp),
          ),
        ),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(
        color: Theme.of(context).colorScheme.onSurface,
        Icons.arrow_back_ios_new,
        size: 20.r,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const SizedBox();
    }
    LogUtils.println('buildResults');
    return SearchResultPage(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const SizedBox();
    }
    return FutureBuilder(
      future: _viewModel.getSuggest(query),
      builder: (BuildContext context, AsyncSnapshot<List<Suggest>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 数据加载中
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // 数据加载错误
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          // 数据加载成功，展示结果
          final List<Suggest> searchResults = snapshot.data ?? [];
          return ListView.builder(
              padding: EdgeInsets.all(15.r),
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // 更新输入框
                    query = searchResults[index].text ?? query;
                    showResults(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      border: BorderDirectional(
                        bottom: BorderSide(
                          width: 0.6,
                          color: Theme.of(context).colorScheme.surfaceContainer,
                        ),
                      ),
                    ),
                    child: Text('${searchResults[index].text}'),
                  ),
                );
              });
        } else {
          // 数据为空
          return const Center(child: Text('No results found'));
        }
      },
    );
  }
}
