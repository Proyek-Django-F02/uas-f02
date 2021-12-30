import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uas_f02/page/all.dart';
import 'package:uas_f02/page/rey/note_form.dart';
import 'package:uas_f02/page/rey/note_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:uas_f02/page/rey/notes_page.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;
  final String name;

  const AddEditNotePage({
    Key? key,
    this.note,
    required this.name,
  }) : super(key: key);
  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String message;
  late String name;

  @override
  void initState() {
    super.initState();
    name = widget.name;
    title = widget.note?.title ?? '';
    message = widget.note?.message ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
        ),
        body: Form(
          key: _formKey,
          child: NoteFormWidget(
            title: title,
            message: message,
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedMessage: (message) =>
                setState(() => this.message = message),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && message.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? Colors.green : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateNote,
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      title: title,
      message: message,
    );

    final id = note.id;

    try {
      final response = await http.post(
          Uri.parse("http://django-f02.herokuapp.com/note/flutter/edit-note/"),
          headers: <String, String>{
            'Content-Type': 'application/json;charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'title': title,
            'message': message,
            'timestamp': DateTime.now().year.toString() +
                "-" +
                DateTime.now().month.toString() +
                '-' +
                DateTime.now().day.toString(),
            'username': name,
            'id': id.toString(),
          }));
      print(title);
      print(id);
      print(name);
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future addNote() async {
    try {
      final response = await http.post(
          Uri.parse("http://django-f02.herokuapp.com/note/flutter/add-note/"),
          headers: <String, String>{
            'Content-Type': 'application/json;charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            // print(response.headers.toString());
            'title': title,
            'message': message,
            'timestamp': DateTime.now().year.toString() +
                "-" +
                DateTime.now().month.toString() +
                '-' +
                DateTime.now().day.toString(),
            'username': name,
          }));

      if (response.statusCode == 200) {
        setState(() => NotesPageState());
      }
    } catch (e) {
      throw (e.toString());
    }
  }
}
