class Suggest {
  Suggest({
    this.id,
    this.url,
    this.text,
    this.isHot,
    this.hotLevel,
  });

  Suggest.fromJson(dynamic json) {
    id = json['id'];
    url = json['url'];
    text = json['text'];
    isHot = json['is_hot'];
    hotLevel = json['hot_level'];
  }

  String? id;
  String? url;
  String? text;
  bool? isHot;
  int? hotLevel;
}