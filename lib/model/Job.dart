import 'Site.dart';

class Job {
  String uuid;
  Site site;
  String areaManagerName;
  String areaManagerNumber;
  String workerName;
  String workerCell;
  double hours;
  double payTotalDay;
  double payPartialDay;
  double payDifferenceDay;
  String arrivedAtWork;
  String verifiedAtWork;
  String leftWorkAt;
  String verifiedLeftWork;
  String startDate;
  String endDate;
  int lunchDuration;

  Job(
      {this.uuid,
      this.site,
      this.areaManagerName,
      this.hours,
      this.payTotalDay,
      this.payPartialDay,this.lunchDuration});

  Job.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        site = Site.fromJson(json['site']),
        areaManagerName = json['area_manager_name'],
        areaManagerNumber = json['area_manager_number'],
        workerName = json['worker_name'],
        workerCell = json['worker_cell'],
        hours = json['hours'].toDouble(),
        payTotalDay = json['pay_total_day'].toDouble(),
        payPartialDay = json['pay_partial_day'].toDouble(),
        payDifferenceDay = json['pay_difference_day'].toDouble(),
        arrivedAtWork = json['arrived_at_work_at'],
        verifiedAtWork = json['verified_at_work'],
        leftWorkAt = json['left_work_at'],
        verifiedLeftWork = json['verified_left_work'],
        startDate = json['start_date'],
        endDate = json['end_date'],
        lunchDuration = json['lunch_duration'];

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
        'lunchDuration': lunchDuration,
      };
}
