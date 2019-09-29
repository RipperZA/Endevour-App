class Site {
  String uuid;
  String name;
  double latitude;
  double longitude;

  Site({this.uuid, this.name, this.latitude, this.longitude});

  Site.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        name = json['name'],
        latitude = json['latitude'],
        longitude = json['longitude'];

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'nalatitudeme': latitude,
        'longitude': longitude,
      };
}
