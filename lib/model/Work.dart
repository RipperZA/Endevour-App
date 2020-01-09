class Work {
  String uuid;
  String name;
  String area;
  double latitude;
  double longitude;
  String startDate;
  String endDate;
  String batch;
  int current_day;
  int total_days;
  String arrivedAtWork;
  String verifiedAtWork;
  String leftWorkAt;
  String verifiedLeftWork;

//  Worker worker;

  Work(
      {this.uuid,
      this.name,
      this.area,
      this.latitude,
      this.longitude,
      this.startDate,
      this.endDate,
      this.batch,
      this.current_day,
      this.total_days,
//      this.worker
      });

  Work.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        name = json['name'],
        area = json['area'],
        latitude = json['address_latitude'].toDouble(),
        longitude = json['address_longitude'].toDouble(),
        startDate = json['start_date'],
        endDate = json['end_date'],
        batch = json['batch'],
        current_day = json['current_day'],
        total_days = json['total_days'],
        arrivedAtWork = json['arrived_at_work_at'],
        verifiedAtWork = json['verified_at_work'],
        leftWorkAt = json['left_work_at'],
        verifiedLeftWork = json['verified_left_work'];

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
