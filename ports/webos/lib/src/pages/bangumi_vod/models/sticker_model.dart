class Sticker {
  String? name;
  String? path;
  List<Lists>? list;

  Sticker({this.name, this.path, this.list});

  Sticker.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    path = json["path"];
    list = json["list"] == null
        ? null
        : (json["list"] as List).map((e) => Lists.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data_ = <String, dynamic>{};
    data_["name"] = name;
    data_["path"] = path;
    if (list != null) {
      data_["list"] = list?.map((e) => e.toJson()).toList();
    }
    return data_;
  }
}

class Lists {
  String? text;
  String? src;

  Lists({this.text, this.src});

  Lists.fromJson(Map<String, dynamic> json) {
    text = json["text"];
    src = json["src"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data_ = <String, dynamic>{};
    data_["text"] = text;
    data_["src"] = src;
    return data_;
  }
}
