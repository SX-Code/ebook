import 'package:e_book_clone/database/book_table.dart';

class MySqlite {
  static forFeature() async {
    var list = [
      BookTable.instan(),
    ];

    for (var entity in list) {
      while (!entity.exists) {
        await Future.delayed(const Duration(milliseconds: 60), () {});
      }
    }
  }
}
