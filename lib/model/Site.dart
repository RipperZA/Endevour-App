class Site {
  String uuid;
  String name;
  double latitude;
  double longitude;
  String fullAddress;

  Site({this.uuid, this.name, this.latitude, this.longitude,this.fullAddress});

  Site.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        name = json['name'],
        latitude = json['address_latitude'],
        longitude = json['address_longitude'],
        fullAddress = json['full_address'];

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'fullAddress': fullAddress,
      };
}
