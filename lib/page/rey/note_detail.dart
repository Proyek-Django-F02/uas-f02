import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:uas_f02/page/rey/note_add_edit.dart';
import 'package:uas_f02/page/rey/note_model.dart';
import 'package:uas_f02/page/rey/notes_page.dart';
import 'package:uas_f02/page/rey/note_model.dart';
import 'package:uas_f02/page/rey/note_repo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class noteDetail extends StatefulWidget {
  final int id;
  final String name;

  const noteDetail({
    Key? key,
    required this.id,
    required this.name,
  }) : super(key: key);

  @override
  noteDetailState createState() => noteDetailState();
}

class noteDetailState extends State<noteDetail> {
  late Note note;
  bool isLoading = false;
  late int id;
  late String name;
  Repo repo = Repo();

  getData(int id, String name) async {
    setState(() => isLoading = true);
    note = await repo.getDataDetail(id, name);
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    id = widget.id;
    name = widget.name;
    super.initState();

    getData(id, name);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(12),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      note.title,
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      note.timestamp,
                      style: TextStyle(color: Colors.blue.shade200),
                    ),
                    SizedBox(height: 8),
                    Text(
                      note.message,
                      style:
                          TextStyle(color: Colors.blue.shade400, fontSize: 18),
                    )
                  ],
                ),
              ),
      );

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditNotePage(note: note, name: name),
        ));

        getData(id, name);
      });

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          try {
            final id = note.id;
            final response = await http.post(
                Uri.parse(
                    "http://django-f02.herokuapp.com/note/flutter/delete-note/"),
                headers: <String, String>{
                  'Content-Type': 'application/json;charset=UTF-8',
                },
                body: jsonEncode(<String, String>{
                  // print(response.headers.toString());
                  'id': id.toString(),
                  'username': name,
                }));

            if (response.statusCode == 200) {
              setState(() => NotesPageState());
            }
          } catch (e) {
            throw (e.toString());
          }

          Navigator.of(context).pop();
        },
      );
}
