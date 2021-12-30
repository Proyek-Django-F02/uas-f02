// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future<String> createPost(
    String title, String body, String topic_id, String email) async {
  final response = await http.post(
      Uri.parse('http://django-f02.herokuapp.com/forum/flutter/add-post/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'body': body,
        'topic_id': topic_id,
        'email': email,
      }));
  if (response.statusCode == 200) {
    Map<String, dynamic> result = json.decode(response.body);
    print(result['result']);
    return result['result'];
  } else if (response.statusCode == 404) {
    return "No Topic yet";
  } else {
    return "Error's Occured";
  }
}

class CreatePost extends StatefulWidget {
  final String topicId, email;
  const CreatePost({Key? key, required this.topicId, required this.email})
      : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Create Post",
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
                    hintText: "Masukkan judul post",
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
                    hintText: "Masukkan body post",
                    labelText: "Body",
                    icon: Icon(Icons.description_sharp),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    var response = createPost(titleController.text,
                        descController.text, widget.topicId, widget.email);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(
                          'submitted',
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
                    titleController.clear();
                    descController.clear();
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
