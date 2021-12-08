import 'package:flutter/material.dart';

class NotesPage extends StatelessWidget {
  final String name;
  final String urlImage;
  final String email;

  const NotesPage({
    Key? key,
    required this.name,
    required this.email,
    required this.urlImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Notes"),
          centerTitle: true,
        ),
      );
}
