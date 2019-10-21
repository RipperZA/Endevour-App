class Work {
  String uuid;
  String name;
  String area;
  double latitude;
  double longitude;
  String startDate;
  String endDate;

  Work({this.uuid, this.name, this.area,this.latitude, this.longitude,this.startDate,this.endDate});

  Work.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        name = json['name'],
        area = json['area'],
        latitude = json['address_latitude'],
        longitude = json['address_longitude'],
        startDate = json['start_date'],
        endDate = json['end_date'];

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'area': area,
    'latitude': latitude,
    'longitude': longitude,
    'startDate': startDate,
    'endDate': endDate,
  };
}
