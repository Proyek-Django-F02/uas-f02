// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CommentUnit extends StatefulWidget {
  final String body, username, time;
  const CommentUnit(
      {Key? key,
      required this.body,
      required this.username,
      required this.time})
      : super(key: key);

  @override
  _CommentUnitState createState() => _CommentUnitState();
}

class _CommentUnitState extends State<CommentUnit> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30.0,
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
                      '@${widget.username}',
                      style: TextStyle(
                          fontSize: 18.5, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      '· 6h',
                      style: TextStyle(fontSize: 17.0),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        alignment: Alignment.centerRight,
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.body,
                  style: TextStyle(fontSize: 17.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
