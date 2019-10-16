class Work {
  String uuid;
  String name;
  String area;
  double latitude;
  double longitude;

  Work({this.uuid, this.name, this.area,this.latitude, this.longitude});

  Work.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        name = json['name'],
        area = json['area'],
        latitude = json['latitude'],
        longitude = json['longitude'];

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'area': area,
    'latitude': latitude,
    'longitude': longitude,
  };
}
