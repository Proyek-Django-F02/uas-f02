import 'dart:convert';

import 'package:uas_f02/page/isyah/model.dart';
import 'package:http/http.dart' as http;

class Repository {
  Future<List> getData(name) async {
    final response = await http.get(Uri.parse('http://localhost:8000/schedule/flutter/activity-list/' + name));
    // final response = await http.get(Uri.parse('https://mocki.io/v1/f542c1c8-90da-4f1c-b45c-80f017871212'));

    if (response.statusCode == 200) {
      // print(response.body);
      Iterable it = jsonDecode(response.body);
      List<ScheduleActivity> activity = it.map((e) => ScheduleActivity.fromJson(e, name)).toList();
      // print("test " + activity[0].activity);
      return activity;
    } else {
      throw Exception('Failed to load Schedule');
    }
  }
}