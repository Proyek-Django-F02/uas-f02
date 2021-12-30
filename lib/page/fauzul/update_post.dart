// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String> updatePost(String title, String body, String post_id) async {
  final response = await http.post(
      Uri.parse('http://localhost:8000/forum/flutter/update-post/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'body': body,
        'post_id': post_id,
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

class UpdatePost extends StatefulWidget {
  final String postId, oldTitle, oldBody;
  const UpdatePost(
      {Key? key,
      required this.postId,
      required this.oldTitle,
      required this.oldBody})
      : super(key: key);

  @override
  _UpdatePostState createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titController;
  late TextEditingController bodyController;

  @override
  void initState() {
    super.initState();
    titController = new TextEditingController(text: widget.oldTitle);
    bodyController = new TextEditingController(text: widget.oldBody);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Update Post",
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
                  controller: titController,
                  // initialValue: widget.oldTitle,
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
                  controller: bodyController,
                  // initialValue: widget.oldBody,
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
                    var response = updatePost(
                        titController.text, bodyController.text, widget.postId);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(
                          '$response',
                          textAlign: TextAlign.center,
                        ),
                        content: Icon(
                          Icons.check_circle_outline,
                          size: 50,
                        ),
                      ),
                    );
                    titController.clear();
                    bodyController.clear();
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
