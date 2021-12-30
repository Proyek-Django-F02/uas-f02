// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'comment_unit.dart';
import 'package:http/http.dart' as http;

Future<String> createComment(String body, String post_id, String email) async {
  final response = await http.post(
      Uri.parse('http://localhost:8000/forum/flutter/add-comment/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'body': body,
        'post_id': post_id,
        'email': email,
      }));
  if (response.statusCode == 200) {
    return response.body;
  } else if (response.statusCode == 404) {
    return "No Post yet";
  } else {
    return "Error Occured";
  }
}

Future<List<Comment>> fetchComment(String pk) async {
  var url = Uri.parse('http://localhost:8000/forum/post/${pk}/json');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    // ignore: unnecessary_new
    return jsonResponse.map((data) => new Comment.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Comment {
  final String author, body, time;

  Comment({
    required this.author,
    required this.body,
    required this.time,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        author: json['username'], body: json['body'], time: json['timestamp']);
  }
}

class CommentList extends StatefulWidget {
  final String title, username, id, description, time, authorEmail, userEmail;
  const CommentList({
    Key? key,
    required this.title,
    required this.username,
    required this.id,
    required this.description,
    required this.time,
    required this.authorEmail,
    required this.userEmail,
  }) : super(key: key);

  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  TextEditingController replyController = TextEditingController();
  late Future<List<Comment>> futureComment;

  @override
  void initState() {
    super.initState();
    futureComment = fetchComment(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              FutureBuilder<List<Comment>>(
                future: futureComment,
                builder: (context, snapshot) {
                  if (!snapshot.hasError) {
                    List<Comment>? comments = snapshot.data;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: comments == null ? 1 : comments.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 30.0,
                                      ),
                                      SizedBox(width: 8.0),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  widget.title,
                                                  style: TextStyle(
                                                      fontSize: 22.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: IconButton(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    icon: const Icon(
                                                        Icons.more_vert),
                                                    onPressed: () {},
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '@${widget.username}',
                                              style: TextStyle(
                                                fontSize: 19.0,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    widget.description,
                                    style: TextStyle(fontSize: 24.5),
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    widget.time,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey[700]),
                                  ),
                                  Divider(
                                    color: Colors.grey[800],
                                    thickness: 0.8,
                                  ),
                                ],
                              ),
                            );
                          }
                          index -= 1;
                          return Column(
                            children: [
                              CommentUnit(
                                  body: comments![index].body,
                                  username: comments[index].author,
                                  time: comments[index].time),
                              Divider(
                                color: Colors.black,
                                thickness: 0.7,
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('${snapshot.error}'));
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              Container(
                height: 45.0,
                padding: EdgeInsets.only(top: 4.0, left: 12.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: replyController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Reply this post',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          createComment(replyController.text, widget.id,
                              widget.userEmail);
                          futureComment = fetchComment(widget.id);
                          replyController.clear();
                        });
                      },
                      icon: Icon(Icons.send),
                      color: Colors.blue,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
