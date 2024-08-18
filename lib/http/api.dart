import 'package:dio/dio.dart';
import 'package:e_book_clone/http/dio_instance.dart';
import 'package:e_book_clone/models/app_upgrade_Info.dart';
import 'package:e_book_clone/utils/constants.dart';

class Api {
  static Api? _instance;

  Api._();

  static Api instance() {
    return _instance ??= Api._();
  }

  Future<AppUprageInfo> getUpgradeInfo() async {
    Response res =
        await DioInstance.instance().get(path: Constants.updateInfoUrl);
    return AppUprageInfo(
      content: res.data['info'] as String,
      url: res.data['url'],
      version: "0.0",    );
  }
}
