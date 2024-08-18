import 'package:e_book_clone/models/base_model.dart';

class UserInfo extends BaseModel {
  UserInfo({
    this.id,
    this.username,
    this.avatar,
  });
  String? id;
  String? username;
  String? avatar;
  bool? isVip;

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    avatar = json['avatar'];
  }

  @override
  Map<String, dynamic> toJson() =>
      {"id": id, "username": username, "avatar": avatar};

  UserInfo.fromDoubanJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['name'] as String;
    avatar = json['avatar'] as String;
    isVip = json['vipInfo']['isVip'] as bool;
  }
}
