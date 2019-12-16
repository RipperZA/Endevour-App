import 'Job.dart';

class JobList {
  String batch;
  String startDate;
  String endDate;
  String siteName;
  String area;
  double totalPay;
  double totalPartialPay;
  double totalDifferencePay;
  double totalHours;
  int numDays;
  List<Job> work;

  JobList(
      this.batch,
      this.startDate,
      this.endDate,
      this.siteName,
      this.area,
      this.totalPay,
      this.totalPartialPay,
      this.totalDifferencePay,
      this.totalHours,
      this.numDays,
      [this.work]);

  factory JobList.fromJson(Map<String, dynamic> json) {
    print(json);

    if (json['items'] != null) {
//      var workObjsJson = json['items'] as List;
//      List _works =
//          workObjsJson.map((workJson) => Work.fromJson(workJson)).toList();
//
//      print(_works);

      return JobList(
          json['batch'],
          json['start_date'],
          json['end_date'],
          json['site_name'],
          json['area'],
          json['total_pay'].toDouble(),
          json['total_partial_pay'].toDouble(),
          json['total_difference_pay'].toDouble(),
          json['total_hours'].toDouble(),
          json['num_days'].toInt(),
          json['items']
              .map((workJson) => Job.fromJson(workJson))
              .toList()
              .cast<Job>());
    } else {
      return JobList(
        json['batch'],
        json['start_date'],
        json['end_date'],
        json['site_name'],
        json['area'],
        json['total_pay'],
        json['total_partial_pay'],
        json['total_difference_pay'],
        json['total_hours'],
        json['num_days'],
//          List<Job>()
      );
    }
  }

//  Map<String, dynamic> toJson() => {
//        'uuid': uuid,
//        'site': site,
//        'areaManagerName': areaManagerName,
//        'workerName': workerName,
//        'workerCell': workerCell,
//        'hours': hours,
//        'payTotalDay': payTotalDay,
//        'payPartialDay': payPartialDay,
//        'payDifferenceDay': payDifferenceDay,
//      };
}
