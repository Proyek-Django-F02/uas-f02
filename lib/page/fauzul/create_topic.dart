// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String> createTopic(String title, String description) async {
  final response = await http.post(
      Uri.parse('http://django-f02.herokuapp.com/forum/flutter/add-topic/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'description': description,
      }));
  if (response.statusCode == 200) {
    Map<String, dynamic> result = json.decode(response.body);
    return result['result'];
  } else {
    return "Error Occured";
  }
}

class CreateTopic extends StatefulWidget {
  const CreateTopic({Key? key}) : super(key: key);

  @override
  State<CreateTopic> createState() => _CreateTopicState();
}

class _CreateTopicState extends State<CreateTopic> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();

  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Create Topic",
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: "Masukkan judul topic",
                    labelText: "Title",
                    icon: Icon(Icons.title),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Judul tidak boleh kosong";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  controller: descController,
                  decoration: InputDecoration(
                    hintText: "Masukkan deskripsi topik",
                    labelText: "Description",
                    icon: Icon(Icons.description_sharp),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {});
                  if (_formKey.currentState!.validate()) {
                    var addTopic =
                        createTopic(titleController.text, descController.text);
                    titleController.clear();
                    descController.clear();
                    // print(addTopic);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(
                          "submitted",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.blue),
                        ),
                        content: Icon(
                          Icons.check_circle_outline,
                          size: 50,
                          color: Colors.blue,
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  "create",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
