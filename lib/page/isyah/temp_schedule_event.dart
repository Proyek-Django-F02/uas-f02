import 'package:flutter/cupertino.dart';

class Event {

  final String title;
  String startTime;
  String endTime;
  String desc = '';
  String type = 'General';

  Event({required this.title, required this.desc, required this.type, required this.startTime, required this.endTime
    // required this.time, required this.description, required this.type
  });

  @override
  String toString() => title;
}