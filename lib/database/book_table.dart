import 'package:e_book_clone/database/base_database.dart';
import 'package:e_book_clone/utils/log_utils.dart';

class BookTable extends BaseDatabase {
  static BookTable? _ins;

  BookTable._();
  
  static BookTable instan() {
    return _ins ??= BookTable._();
  }
  @override
  String tableName = "book_table";

  //建表函数,当数据库中没有这个表时,基类会触发这个函数
  @override
  onCreate(db, version) async {
    LogUtils.println("创建 $tableName 数据表");
    await db.execute("""
      CREATE TABLE $tableName (
        id integer primary key,
        cover TEXT,
        price REAL,
        title TEXT,
        authorName TEXT,
        subTitle TEXT,
        rate REAL,
        page INTEGER,
        read INTEGER
      )
    """);
  }

  ///当数据库升级时,基类会触发的函数
  @override
  onUpgrade(db, oldVersion, newVersion) {}

  ///当数据库降级,基类会触发的函数
  @override
  onDowngrade(db, oldVersion, newVersion) {}
}
