


class Site{
  String uuid;
  String name;

  Site({this.uuid, this.name});

  Site.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
    'uuid' : uuid,
    'name' : name,
  };

}