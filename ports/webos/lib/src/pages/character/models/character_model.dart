class Character {
  int? id;
  String? name;
  List<String>? aka;
  String? gender;
  String? summary;
  String? image;
  List<Actors>? actors;

  Character(
      {this.id,
      this.name,
      this.aka,
      this.gender,
      this.summary,
      this.image,
      this.actors});

  Character.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    aka = json["aka"] == null ? null : List<String>.from(json["aka"]);
    gender = json["gender"];
    summary = json["summary"];
    image = json["image"];
    actors = json["actors"] == null
        ? null
        : (json["actors"] as List).map((e) => Actors.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data_ = <String, dynamic>{};
    data_["id"] = id;
    data_["name"] = name;
    if (aka != null) {
      data_["aka"] = aka;
    }
    data_["gender"] = gender;
    data_["summary"] = summary;
    data_["image"] = image;
    if (actors != null) {
      data_["actors"] = actors?.map((e) => e.toJson()).toList();
    }
    return data_;
  }
}

class Actors {
  int? id;
  String? name;
  String? image;

  Actors({this.id, this.name, this.image});

  Actors.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    image = json["image"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data_ = <String, dynamic>{};
    data_["id"] = id;
    data_["name"] = name;
    data_["image"] = image;
    return data_;
  }
}
