class Worker {
  String uuid;
  String name;
  String surname;
  String cellNumber;

  Worker({
    this.uuid,
    this.name,
    this.surname,
    this.cellNumber,
  });

  Worker.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        name = json['name'],
        surname = json['surname'],
        cellNumber = json['cell_number'];

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'surname': surname,
        'cell_number': cellNumber,
      };
}
