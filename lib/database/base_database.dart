import 'package:e_book_clone/utils/log_utils.dart';
import 'package:sqflite/sqflite.dart';

/// https://juejin.cn/post/7195874225949294651
abstract class BaseDatabase {
  static const String _dbName = "e_book"; // 数据库名称
  static const int _newVersion = 1; // 数据库版本
  static int _oldVersion = 0; // 上一个数据库版本
  static String? _dbBasePath; // 数据库地址
  static Database? _database; // 数据库实例
  abstract String tableName; //数据表名称,在子类中必须要重写的字段
  bool exists = false; //数据表是否存在

  ///建表函数, 在子类中必须重写
  Future<void> onCreate(Database db, int version);

  ///数据库升级时触发的函数,子类中可以根据需要时进行重写
  onUpgrade(Database db, int oldVersion, int newVersion) {}

  ///数据库降级触发的函数,子类中可以根据需要时进行重写
  onDowngrade(Database db, int oldVersion, int newVersion) {}

  BaseDatabase() {
    _initDatabase();
  }
  Database get database => _database!;

  // 初始化数据库
  Future<Database> _initDatabase() async {
    //获取数据库的位置
    _dbBasePath ??= "${await getDatabasesPath()}/$_dbName.db";

    _database ??= await openDatabase(
      _dbBasePath!,
      version: _newVersion,
      onUpgrade: (db, oldVersion, newVersion) {
        _oldVersion = oldVersion;
      },
      onDowngrade: (db, oldVersion, newVersion) {
        _oldVersion = oldVersion;
      },
    );

    //判断表是否存在
    exists = await tableExists();
    if (!exists) {
      //表不存在时调用建表函数
      await onCreate(_database!, _newVersion);
      exists = true;
    }

    //数据第一次创建时_oldVersion等于0, 所以忽略
    if (_oldVersion != 0) {
      if (_oldVersion > _newVersion) {
        LogUtils.println("_oldVersion: $_oldVersion");
        LogUtils.println("_newVersion: $_newVersion");
        //数据库降级了,如果子类重写了onDowngrade方法, 则调用的是子类的;
        await onDowngrade(
          _database!,
          await _database!.getVersion(),
          _newVersion,
        );
      } else if (_oldVersion < _newVersion) {
        LogUtils.println("_oldVersion: $_oldVersion");
        LogUtils.println("_newVersion: $_newVersion");
        //数据库升级了,如果子类重写了onUpgrade方法, 则调用的是子类的;
        await onUpgrade(
          _database!,
          _oldVersion,
          _newVersion,
        );
      }
    }

    return _database!;
  }

  /// 插入数据
  Future insert(Map<String, dynamic> values) async {
    List res = await find(where: {"id": values["id"]});
    if (res.isNotEmpty) {
      return -1;
    }
    return database.insert(tableName, values);
  }

  /// 插入数据
  Future remove(Map<String, dynamic> keys) async {
    List<String> where = [];
    keys.forEach((key, value) {
      where.add('$key=$value');
    });
    return database.delete(tableName, where: where.join(' and '));
  }

  /// 修改数据
  Future update(Map<String, dynamic> keys, Map<String, dynamic> values) {
    List<String> where = [];
    keys.forEach((key, value) {
      if (value.runtimeType == String) {
        where.add("$key='$value'");
      } else {
        where.add("$key=$value");
      }
    });

    return database.update(
      tableName,
      values,
      where: where.isEmpty ? null : where.join(" and "),
    );
  }

  ///缓存的数据
  static final Map<String, List<Map<String, Object?>>> _findCache = {};

  ///查找数据
  Future<List<Map<String, Object?>>> find({
    Map<String, dynamic>? where,
    int? page,
    int? pageSize,
  }) async {
    List<String> keys = where?.keys.toList() ?? [];

    List<String> whereList = [];
    for (int i = 0; i < keys.length; i++) {
      String key = keys[i];
      if (where![key].runtimeType == String) {
        whereList.add("$key='${where[key]}'");
      } else {
        whereList.add("$key=${where[key]}");
      }
    }
    String sql = whereList.join(" and ");
    String mapKey = "${tableName}_${sql}_page=${page}_pageSize=$pageSize";

    List data = sql.isEmpty ? [] : (_findCache[mapKey] ?? []);
    if (data.isNotEmpty) {
      return _findCache[mapKey]!;
    }

    var result = await database.query(
      tableName,
      where: sql.isEmpty ? null : sql,
      offset: page == null ? null : (page - 1) * (pageSize ?? 1),
      limit: pageSize,
    );
    if (sql.isNotEmpty) {
      _findCache[mapKey] = result;
    }
    return result;
  }

  rawQuery(String sql) async {
    return database.rawQuery(sql);
  }

  Future<bool> tableExists() async {
    var res = await _database!.rawQuery(
      "SELECT * FROM sqlite_master WHERE TYPE = 'table' AND NAME = '$tableName'",
    );
    return res.isNotEmpty;
  }
}
