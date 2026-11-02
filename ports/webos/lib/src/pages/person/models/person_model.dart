class Person {
    int? id;
    String? name;
    List<String>? aka;
    String? gender;
    String? summary;
    String? image;

    Person({this.id, this.name, this.aka, this.gender, this.summary, this.image});

    Person.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        name = json["name"];
        aka = json["aka"] == null ? null : List<String>.from(json["aka"]);
        gender = json["gender"];
        summary = json["summary"];
        image = json["image"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data_ = <String, dynamic>{};
        data_["id"] = id;
        data_["name"] = name;
        if(aka != null) {
            data_["aka"] = aka;
        }
        data_["gender"] = gender;
        data_["summary"] = summary;
        data_["image"] = image;
        return data_;
    }
}