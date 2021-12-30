// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'comment_list.dart';

class PostUnit extends StatefulWidget {
  final String title, description, username, time, id, authorEmail, userEmail;
  const PostUnit(
      {Key? key,
      required this.title,
      required this.description,
      required this.username,
      required this.time,
      required this.id,
      required this.authorEmail,
      required this.userEmail})
      : super(key: key);

  @override
  _PostUnitState createState() => _PostUnitState();
}

class _PostUnitState extends State<PostUnit> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CommentList(
                    title: widget.title,
                    username: widget.username,
                    id: widget.id,
                    description: widget.description,
                    time: widget.time,
                    authorEmail: widget.authorEmail,
                    userEmail: widget.userEmail))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage:
                  AssetImage('assets/images/profile_image_default.png'),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 2.0),
                      Text(
                        '@' + widget.username,
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(width: 2.0),
                      Text(
                        '· ' + 'time ' + 'h',
                        style: TextStyle(fontSize: 17.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Visibility(
                        visible: widget.userEmail == widget.authorEmail,
                        child: Expanded(
                          flex: 1,
                          child: IconButton(
                            alignment: Alignment.centerRight,
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.description,
                    style: TextStyle(fontSize: 18.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
