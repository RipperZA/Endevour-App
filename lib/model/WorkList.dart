import 'Work.dart';
import 'Worker.dart';

class WorkList {
  String batch;
  String startDate;
  String endDate;
  String siteName;
  String area;
  double totalPay;
  double totalHours;
  int numDays;
  Worker worker;
  List<Work> work;

  WorkList(this.batch, this.startDate, this.endDate, this.siteName, this.area,
      this.totalPay, this.totalHours, this.numDays, this.worker, [this.work]);

  factory WorkList.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
//      var workObjsJson = json['items'] as List;
//      List _works =
//          workObjsJson.map((workJson) => Work.fromJson(workJson)).toList();

      return WorkList(
          json['batch'],
          json['start_date'],
          json['end_date'],
          json['site_name'],
          json['area'],
          json['total_pay'].toDouble(),
          json['total_hours'].toDouble(),
          json['num_days'],
          Worker.fromJson(json['worker']),
          json['items']
              .map((workJson) => Work.fromJson(workJson))
              .toList()
              .cast<Work>());
    } else {
      return WorkList(
          json['batch'],
          json['start_date'],
          json['end_date'],
          json['site_name'],
          json['area'],
          json['total_pay'].toDouble(),
          json['total_hours'].toDouble(),
          json['num_days'],
          Worker.fromJson(json['worker']),
//           List<Work>()
      );
    }
  }

  Work getElement(id) {
    return this.work.first;
  }

  String customLength() {
    return '${this.work.length}';
  }

  @override
  String toString() {
    return '${this.work.length}';
  }
}
