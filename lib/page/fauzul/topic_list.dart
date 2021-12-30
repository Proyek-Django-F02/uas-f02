import 'dart:convert';

import 'package:flutter/material.dart';
import 'post_list.dart';
import 'package:http/http.dart' as http;

Future<List<Topic>> fetchTopic() async {
  var url = Uri.parse('http://django-f02.herokuapp.com/forum/json');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    // ignore: unnecessary_new
    return jsonResponse.map((data) => new Topic.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Topic {
  final String id;
  final String title;
  final String description;

  Topic({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
        id: json['id'].toString(),
        title: json['title'],
        description: json['description']);
  }
}

class TopicList extends StatefulWidget {
  final String userEmail;
  const TopicList({Key? key, required this.userEmail}) : super(key: key);

  @override
  _TopicListState createState() => _TopicListState();
}

class _TopicListState extends State<TopicList> {
  late Future<List<Topic>> futureTopic;

  @override
  void initState() {
    super.initState();
    futureTopic = fetchTopic();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            futureTopic = fetchTopic();
          });
        },
        child: FutureBuilder<List<Topic>>(
          future: futureTopic,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Topic>? topics = snapshot.data;
              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: topics!.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostList(
                                  topic_id: topics[index].id,
                                  topic_title: topics[index].title,
                                  userEmail: widget.userEmail,
                                ))),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 14.0),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.blue.withOpacity(0.8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            topics[index].title,
                            style: const TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Divider(
                            color: Colors.white,
                            thickness: 1.7,
                            indent: 60.0,
                            endIndent: 60.0,
                          ),
                          Text(
                            topics[index].description,
                            style: const TextStyle(
                              fontSize: 19.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}"));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
