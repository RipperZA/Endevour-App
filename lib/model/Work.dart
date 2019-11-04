import 'package:flutter_ui_collections/model/Worker.dart';

class Work {
  String uuid;
  String name;
  String area;
  double latitude;
  double longitude;
  String startDate;
  String endDate;
//  Worker worker;

  Work(
      {this.uuid,
      this.name,
      this.area,
      this.latitude,
      this.longitude,
      this.startDate,
      this.endDate,
//      this.worker
      });

  Work.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        name = json['name'],
        area = json['area'],
        latitude = json['address_latitude'].toDouble(),
        longitude = json['address_longitude'].toDouble(),
        startDate = json['start_date'],
        endDate = json['end_date'];
//        worker = Worker.fromJson(json['worker']);

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'area': area,
        'latitude': latitude,
        'longitude': longitude,
        'startDate': startDate,
        'endDate': endDate,
//        'worker': worker,
      };
}
