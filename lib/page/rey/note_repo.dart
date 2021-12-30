import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uas_f02/page/rey/note_model.dart';

class Repo {
  Future getAllData(String name) async {
    try {
      final response = await http.get(Uri.parse(
          'http://django-f02.herokuapp.com/note/flutter/list-note/' + name));

      if (response.statusCode == 200) {
        print(response.body);
        Iterable it = jsonDecode(response.body);
        List<Note> notes = it.map((e) => Note.fromJson(e)).toList();
        return notes;
      }
    } catch (e) {}
  }

  Future getDataDetail(int id, String name) async {
    Note data;
    try {
      final response = await http.get(Uri.parse(
          'http://django-f02.herokuapp.com/note/flutter/detail-note/' +
              name +
              '/' +
              id.toString()));

      if (response.statusCode == 200) {
        data = Note.fromJson(jsonDecode(response.body));

        return data;
      }
    } catch (e) {}
  }
}
