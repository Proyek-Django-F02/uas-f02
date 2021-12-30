// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'create_post.dart';
import 'post_unit.dart';
import 'package:http/http.dart' as http;

Future<List<Post>> fetchPost(String pk) async {
  var url = Uri.parse('http://django-f02.herokuapp.com/forum/topic/$pk/json');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    // ignore: unnecessary_new
    return jsonResponse.map((data) => new Post.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Post {
  final String id;
  final String author;
  final String topicId;
  final String title;
  final String description;
  final String time;
  final String authorEmail;

  Post({
    required this.id,
    required this.author,
    required this.topicId,
    required this.title,
    required this.description,
    required this.time,
    required this.authorEmail,
  });
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'].toString(),
        author: json['username'],
        topicId: json['topic_id'].toString(),
        title: json['title'],
        description: json['body'],
        time: json['timestamp'].toString(),
        authorEmail: json['email']);
  }
}

class PostList extends StatefulWidget {
  final String topic_id, topic_title, userEmail;
  const PostList(
      {Key? key,
      required this.topic_id,
      required this.topic_title,
      required this.userEmail})
      : super(key: key);

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  late Future<List<Post>> futurePost;

  @override
  void initState() {
    super.initState();
    futurePost = fetchPost(widget.topic_id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.topic_title,
            style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  futurePost = fetchPost(widget.topic_id);
                });
              },
              child: FutureBuilder<List<Post>>(
                future: futurePost,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Post>? posts = snapshot.data;
                    return ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: posts!.length,
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey[800],
                        thickness: 0.8,
                      ),
                      itemBuilder: (context, index) {
                        return PostUnit(
                          title: posts[index].title,
                          description: posts[index].description,
                          username: posts[index].author,
                          time: posts[index].time.toString(),
                          id: posts[index].id,
                          authorEmail: posts[index].authorEmail,
                          userEmail: widget.userEmail,
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("${snapshot.error}"));
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(20.0),
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CreatePost(
                            topicId: widget.topic_id,
                            email: widget.userEmail))),
                child: Text(
                  '+ Create Post',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
