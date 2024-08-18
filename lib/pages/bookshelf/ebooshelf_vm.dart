import 'package:e_book_clone/http/spider/json_api.dart';
import 'package:e_book_clone/models/ebookshelf.dart';
import 'package:e_book_clone/user/user_provider.dart';
import 'package:e_book_clone/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EBooshelfViewModel extends ChangeNotifier {
  bool _dispose = false;
  EBookshelf? _shelfBooks;
  String? _userId;
  int _currPage = 0;

  set isDispose(bool dispose) {
    _dispose = dispose;
  }

  EBookshelf? get shelfBook => _shelfBooks;

  Future getData(Map<String, dynamic> variables, bool loadMore,
      {VoidCallback? needLoginCallback}) async {
    if (_userId == null || _userId!.isEmpty) {
      String? userId =
          Provider.of<UserProvider>(ToastUtils.context, listen: false).userInfo?.id;
      if (userId == null) {
        ToastUtils.showErrorMsg('登录后更精彩');
        return;
      }
      _userId = userId;
    }
    // 获取书架数据
    await getShelfBooks(variables, loadMore).then((needLogin) {
      if (needLogin) {
        ToastUtils.showErrorMsg('请重新登录');
        needLoginCallback?.call();
      }
    });
  }

  Future getShelfBooks(Map<String, dynamic> variables, bool loadMore) async {
    if (loadMore) {
      _currPage++;
    } else {
      _currPage = 0;
      shelfBook?.books.clear();
    }

    EBookshelf? res =
        await JsonApi.instance().fetchBookshelfBook(variables, _currPage);
    if (res == null) {
      // 出错
      _shelfBooks = EBookshelf(total: 0, books: []);
      return true;
    }

    // 赋值
    if (_shelfBooks == null) {
      _shelfBooks = res;
    } else {
      _shelfBooks!.books.addAll(res.books);
    }

    // 复原分页下标
    if (res.books.isEmpty && _currPage > 0) {
      _currPage--;
    }
    
    if (_dispose) return;
    notifyListeners();

    return false;
  }
}
