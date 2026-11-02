class ThreadCollection {
  bool? error;
  String? message;
  Body? body;

  ThreadCollection({this.error, this.message, this.body});

  ThreadCollection.fromJson(Map<String, dynamic> json) {
    error = json["error"];
    message = json["message"];
    body = json["body"] == null ? null : Body.fromJson(json["body"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data_ = <String, dynamic>{};
    data_["error"] = error;
    data_["message"] = message;
    if (body != null) {
      data_["body"] = body?.toJson();
    }
    return data_;
  }
}

class Body {
  List<Data>? data;
  int? page;
  bool? prev;
  bool? next;
  int? total;

  Body({this.data, this.page, this.prev, this.next, this.total});

  Body.fromJson(Map<String, dynamic> json) {
    data = json["data"] == null
        ? null
        : (json["data"] as List).map((e) => Data.fromJson(e)).toList();
    page = json["page"];
    prev = json["prev"];
    next = json["next"];
    total = json["total"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data_ = <String, dynamic>{};
    if (data != null) {
      data_["data"] = data?.map((e) => e.toJson()).toList();
    }
    data_["page"] = page;
    data_["prev"] = prev;
    data_["next"] = next;
    data_["total"] = total;
    return data_;
  }
}

class Data {
  int? date;
  int? id;
  String? title;
  String? titleZh;
  bool? nsfw;
  int? width;
  int? height;
  int? count;
  bool? ai;
  String? color;
  String? image;

  Data(
      {this.date,
      this.id,
      this.title,
      this.titleZh,
      this.nsfw,
      this.width,
      this.height,
      this.count,
      this.ai,
      this.color,
      this.image});

  Data.fromJson(Map<String, dynamic> json) {
    date = json["date"];
    id = json["id"];
    title = json["title"];
    titleZh = json["title_zh"];
    nsfw = json["nsfw"];
    width = json["width"];
    height = json["height"];
    count = json["count"];
    ai = json["ai"];
    color = json["color"];
    image = json["image"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data_ = <String, dynamic>{};
    data_["date"] = date;
    data_["id"] = id;
    data_["title"] = title;
    data_["title_zh"] = titleZh;
    data_["nsfw"] = nsfw;
    data_["width"] = width;
    data_["height"] = height;
    data_["count"] = count;
    data_["ai"] = ai;
    data_["color"] = color;
    data_["image"] = image;
    return data_;
  }
}
