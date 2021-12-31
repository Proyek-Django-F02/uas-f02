class ScheduleActivity {
  String activity;
  int year;
  int month;
  int day;
  String startTime;
  String endTime;
  String type = 'General';
  String desc = '';
  String name;
  String id;

  ScheduleActivity({
    required this.activity,
    required this.year,
    required this.month,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.desc,
    required this.name,
    required this.id
  });

  factory ScheduleActivity.fromJson(Map<String, dynamic> json, name) {
    return ScheduleActivity(
        activity: json['activity'],
        year: json['year'],
        month: json['month'],
        day: json['day'],
        startTime: json['start_time'],
        endTime: json['end_time'],
        type: json['type'],
        desc: json['desc'],
        name: name,
        id: json['id'].toString()
    );
  }

  @override
  String toString() => activity;
}