class BangumiCollection {
  bool? error;
  String? message;
  Body? body;

  BangumiCollection({this.error, this.message, this.body});

  BangumiCollection.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? title;
  int? episode;
  int? episodesTotal;
  String? status;
  int? date;
  String? image;
  String? tagline;

  Data(
      {this.id,
      this.title,
      this.episode,
      this.episodesTotal,
      this.status,
      this.date,
      this.image,
      this.tagline});

  Data.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    episode = json["episode"];
    episodesTotal = json["episodes_total"];
    status = json["status"];
    date = json["date"];
    image = json["image"];
    tagline = json["tagline"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data_ = <String, dynamic>{};
    data_["id"] = id;
    data_["title"] = title;
    data_["episode"] = episode;
    data_["episodes_total"] = episodesTotal;
    data_["status"] = status;
    data_["date"] = date;
    data_["image"] = image;
    data_["tagline"] = tagline;
    return data_;
  }
}
