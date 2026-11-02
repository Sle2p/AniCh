class CharacterBangumi {
  List<Data>? data;
  bool? next;

  CharacterBangumi({this.data, this.next});

  CharacterBangumi.fromJson(Map<String, dynamic> json) {
    data = json["data"] == null
        ? null
        : (json["data"] as List).map((e) => Data.fromJson(e)).toList();
    next = json["next"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data_ = <String, dynamic>{};
    if (data != null) {
      data_["data"] = data?.map((e) => e.toJson()).toList();
    }
    data_["next"] = next;
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
