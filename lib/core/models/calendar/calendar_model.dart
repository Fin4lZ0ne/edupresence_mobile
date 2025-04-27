class GetHolidays {
  int id;
  String information;
  DateTime dateStart;
  DateTime dateEnd;
  String type;

  GetHolidays({
    required this.id,
    required this.information,
    required this.dateStart,
    required this.dateEnd,
    required this.type,
  });

  factory GetHolidays.fromJson(Map<String, dynamic> json) {
    return GetHolidays(
      id: json['id'],
      information: json['information'],
      dateStart: DateTime.parse(json['date_start']),
      dateEnd: DateTime.parse(json['date_end']),
      type: json['type'],
    );
  }
}
