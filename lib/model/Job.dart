import 'Site.dart';

class Job {
  String uuid;
  Site site;
  String areaManagerName;
  int hours;
  double payTotalDay;
  double payPartialDay;

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
        hours = json['hours'],
        payTotalDay = json['pay_total_day'],
        payPartialDay = json['pay_partial_day'];

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'site': site,
        'areaManagerName': areaManagerName,
        'hours': hours,
        'payTotalDay': payTotalDay,
        'payPartialDay': payPartialDay,
      };
}