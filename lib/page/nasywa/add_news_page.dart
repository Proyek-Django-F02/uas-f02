import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uas_f02/widget/button_widget.dart';
import 'package:http/http.dart' as http;

class AddNewsPage extends StatefulWidget {
  final String name;
  final String urlImage;
  final String email;

  const AddNewsPage({
    Key? key,
    required this.name,
    required this.email,
    required this.urlImage,
  }) : super(key: key);

  @override
  _AddNewsPageState createState() => _AddNewsPageState();

}

class _AddNewsPageState extends State<AddNewsPage> {
  final formKey = GlobalKey<FormState>();
  late String title = '';
  late String desc = '';

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.blue,
      title: Text("Add News"),
      centerTitle: true,
    ),
    body: Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          buildTitle(),
          const SizedBox(height: 16),
          buildDesc(),
          const SizedBox(height: 16),
          buildSubmit(),
        ],
      ),
    ),
  );

  Widget buildTitle() => TextFormField(
    textInputAction: TextInputAction.done,
    validator: (value) {
      if (value!.length > 0) {
        return null;
      } else {
        return 'This field cannot be empty';
      }
    },
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: "Title",
      hintText: "News Headline",
    ),
    maxLength: 50,
    onChanged: (value) => setState(() => title = value),

  );

  Widget buildDesc() => TextFormField(
    textInputAction: TextInputAction.done,
    validator: (value) {
      if (value!.length > 0) {
        return null;
      } else {
        return 'This field cannot be empty';
      }
    },
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: "News",
      alignLabelWithHint: true,
      hintText: "News Article",
    ),
    maxLines: 10,
    onChanged: (value) => setState(() => desc = value),
  );

  Widget buildSubmit() => ElevatedButton(
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          formKey.currentState!.save();
          await submitNews();
        }
      },
      child: Text("Submit")
  );

  Future submitNews() async{
    final response = await http.post(
        Uri.parse("http://django-f02.herokuapp.com/user/flutter/add-news"),
        headers: <String, String>{'Content-Type': 'application/json;charset=UTF-8'},
        body: jsonEncode(
          <String, String> {
            'title' : title,
            'desc' : desc,
          }
        )
    );

    if (response.statusCode == 200) {
      Navigator.of(context).pop();
    }

  }
}