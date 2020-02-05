class Site {
  String uuid;
  String name;
  double latitude;
  double longitude;
  String fullAddress;

  Site({this.uuid, this.name, this.latitude, this.longitude,this.fullAddress});

  Site.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'].toString(),
        name = json['name'].toString(),
        latitude = json['address_latitude'].toDouble(),
        longitude = json['address_longitude'].toDouble(),
        fullAddress = json['full_address'].toString();

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'fullAddress': fullAddress,
      };
}
