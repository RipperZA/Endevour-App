import 'package:flutter_ui_collections/model/Worker.dart';

import 'Work.dart';

class WorkAreaManager {
  Work work;
  Worker worker;

  WorkAreaManager({this.work, this.worker});

  WorkAreaManager.fromJson(Map<String, dynamic> json)
      :
        work = Work.fromJson(json['work']),
        worker = Worker.fromJson(json['worker']);

  Map<String, dynamic> toJson() => {
        'work': work,
        'worker': worker,
      };
}
