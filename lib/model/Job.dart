import 'Site.dart';

class Job {
  String uuid;
  Site site;
  String areaManagerName;
  String workerName;
  String workerCell;
  int hours;
  double payTotalDay;
  double payPartialDay;
  double payDifferenceDay;
  String arrivedAtWork;
  String verifiedAtWork;
  String leftWorkAt;
  String verifiedLeftWork;

  Job(
      {this.uuid,
      this.site,
      this.areaManagerName,
      this.hours,
      this.payTotalDay,
      this.payPartialDay});

  Job.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        site = Site.fromJson(json['site']),
        areaManagerName = json['area_manager_name'],
        workerName = json['worker_name'],
        workerCell = json['worker_cell'],
        hours = json['hours'],
        payTotalDay = json['pay_total_day'].toDouble(),
        payPartialDay = json['pay_partial_day'].toDouble(),
        payDifferenceDay = json['pay_difference_day'].toDouble(),
        arrivedAtWork = json['arrived_at_work_at'],
        verifiedAtWork = json['verified_at_work'],
        leftWorkAt = json['left_work_at'],
        verifiedLeftWork = json['verified_left_work'];

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'site': site,
        'areaManagerName': areaManagerName,
        'workerName': workerName,
        'workerCell': workerCell,
        'hours': hours,
        'payTotalDay': payTotalDay,
        'payPartialDay': payPartialDay,
        'payDifferenceDay': payDifferenceDay,
      };
}
