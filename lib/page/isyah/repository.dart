import 'dart:convert';

import 'package:uas_f02/page/isyah/model.dart';
import 'package:http/http.dart' as http;

class Repository {
  Future<List> getData(name) async {
    final response = await http.get(Uri.parse('http://django-f02.herokuapp.com/schedule/flutter/activity-list/' + name));

    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body);
      List<ScheduleActivity> activity = it.map((e) => ScheduleActivity.fromJson(e, name)).toList();
      return activity;
    } else {
      throw Exception('Failed to load Schedule');
    }
  }

  Future postData(String name, String activity, int year, int month, int day, String startTime, String endTime, String type, String desc) async {
    try {
      final response = await http.post(
          Uri.parse(
            'http://django-f02.herokuapp.com/schedule/flutter/add/'),
          headers: <String, String>{
            'Content-Type':
            'application/json;charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'username': name,
            'activity': activity,
            'year': year,
            'month': month,
            'day': day,
            'start_time': startTime,
            'end_time': endTime,
            'type': type,
            'desc': desc
          }));
      final Map parsed = json.decode(response.body);
      String res = "Tidak berhasil";

      if (response.statusCode == 200) {
        print(response.body.toString());
        res = "Berhasil";
      }
      return res;
    } catch (e) {
      print("error here");
      print(e.toString());
    }
  }

  Future deleteData(String id) async {
    try {
      final response = await http.delete(Uri.parse('http://django-f02.herokuapp.com/schedule/flutter/delete/' + id));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}