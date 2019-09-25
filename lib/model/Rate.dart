import 'dart:ffi';

class Rate {
  String uuid;
  String name;
  String code;
  String description;
  double ratePerHour;

  Rate({
    this.uuid,
    this.name,
    this.code,
    this.description,
    this.ratePerHour,
  });

  Rate.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        name = json['name'],
        code = json['code'],
        description = json['description'],
        ratePerHour = json['rate_per_hour'];

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'code': code,
        'description': description,
        'ratePerHour': ratePerHour,
      };
}
