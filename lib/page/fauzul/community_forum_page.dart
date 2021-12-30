import 'package:flutter/material.dart';
import 'package:uas_f02/page/fauzul/topic_list.dart';

import 'create_topic.dart';

class CommunityForumPage extends StatelessWidget {
  final String name;
  final String urlImage;
  final String email;

  const CommunityForumPage({
    Key? key,
    required this.name,
    required this.email,
    required this.urlImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Community Forum"),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            TopicList(userEmail: email),
            Container(
              margin: EdgeInsets.all(20.0),
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    side: BorderSide(width: 3.0, color: Colors.blue)),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateTopic())),
                child: Text(
                  '+ Create Topic',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
}
