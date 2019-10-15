class Work {
  String uuid;
  String name;
  String area;

  Work({this.uuid, this.name, this.area});

  Work.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        name = json['name'],
        area = json['area'];

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'area': area,
  };
}
