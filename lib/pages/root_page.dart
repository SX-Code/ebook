import 'package:e_book_clone/json/root_app_json.dart';
import 'package:e_book_clone/pages/douban_read/douban_read_page.dart';
import 'package:e_book_clone/pages/home/home_page.dart';
import 'package:e_book_clone/pages/my_book/my_book_page.dart';
import 'package:e_book_clone/pages/ebook_store/store_page.dart';
import 'package:e_book_clone/pages/bottom_nav_provider.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    var bg = Theme.of(context).colorScheme.surface;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: bg,
        surfaceTintColor: bg,
      ),
      backgroundColor: bg,
      bottomNavigationBar: _getBottomNavigator(context),
      body: LazyLoadIndexedStack(
        index: Provider.of<BottomNavProvider>(context).currentIndex,
        children: const [
          HomePage(pageIndex: 0),
          DoubanReadPage(pageIndex: 1),
          StorePage(pageIndex: 2),
          MyBookPage(pageIndex: 3),
        ],
      ),
    );
  }

  Widget _getBottomNavigator(BuildContext context) {
    var bottomNavProvider =
        Provider.of<BottomNavProvider>(context, listen: false);
    return SalomonBottomBar(
      currentIndex: Provider.of<BottomNavProvider>(context).currentIndex,
      onTap: (index) {
        if (bottomNavProvider.currentIndex == index) {
          // 两次点击同一个页面，刷新当前页面数据
          bottomNavProvider.refresh(index);
        } else {
          bottomNavProvider.currentIndex = index;
        }
      },
      items: List.generate(
        rootAppJson.length,
        (index) {
          return SalomonBottomBarItem(
            selectedColor: Theme.of(context).colorScheme.onSurface,
            unselectedColor: Theme.of(context).colorScheme.inversePrimary,
            icon: Icon(rootAppJson[index]['icon']),
            title: Text(rootAppJson[index]['text']),
          );
        },
      ),
    );
  }
}
