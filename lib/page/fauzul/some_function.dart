import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:uas_f02/page/fauzul/update_post.dart';

void modalBottomSheetMenu(context, String postId, String title, String body) {
  showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          height: MediaQuery.of(context).size.width * 0.30,
          color: Colors.transparent, //could change this to Color(0xFF737373),
          //so you don't have to change MaterialApp canvasColor
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(30.0),
                      topRight: const Radius.circular(30.0))),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => UpdatePost(
                                      postId: postId,
                                      oldTitle: title,
                                      oldBody: body,
                                    )));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 0.75, 40),
                      ),
                      child: Text(
                        'edit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ElevatedButton(
                      onPressed: () {
                        deletePost(postId);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 0.75, 40),
                      ),
                      child: Text(
                        'delete',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )),
        );
      });
}

Future<String> deletePost(String postId) async {
  final response = await http.post(
      Uri.parse('http://localhost:8000/forum/flutter/delete-post/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'post_id': postId,
      }));
  if (response.statusCode == 200) {
    Map<String, dynamic> x = json.decode(response.body);
    print(x['result']);
    return response.body;
  } else if (response.statusCode == 404) {
    return "No Topic yet";
  } else {
    return "Error's Occured";
  }
}
