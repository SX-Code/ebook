import 'package:e_book_clone/http/api.dart';
import 'package:e_book_clone/models/app_upgrade_Info.dart';
import 'package:package_info/package_info.dart';

class CheckUpdate {

  static Future<AppUprageInfo?> checkUpdate() async {
    AppUprageInfo info = await Api.instance().getUpgradeInfo();

    // 检查是否需要更新
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if ( packageInfo.version != info.version) {
      return info;
    }
    return null;
  } 
}