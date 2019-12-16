import 'Work.dart';

class WorkList {
  List work;
  int numItems;

  WorkList(this.numItems,[this.work]);

  WorkList.fromJson(Map<String, dynamic> json):
        numItems= json['num_items'],
        work = json['items'].map((workJson) => Work.fromJson(workJson)).toList();
//  {
//
//    if (json['items'] != null) {
//      var workObjsJson = json['items'] as List;
//
//      List _works = workObjsJson.map((workJson) => Work.fromJson(workJson)).toList();
//
//
//      return WorkList(
//          json['num_items'],
//          _works
//      );
//    } else {
//      return WorkList(
//        json['num_items'],
//      );
//    }
//  }

  Work getElement(id)
  {
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
